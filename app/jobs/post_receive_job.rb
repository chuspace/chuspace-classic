# frozen_string_literal: true

require 'mimemagic'

class PostReceiveJob < ApplicationJob
  queue_as :critical
  attr_reader :repository, :author, :commit_sha

  def perform(author_id:, repository_id:, commit_sha:)
    @author = User.find_by(id: author_id)
    @commit_sha = commit_sha
    @repository = Repository.find_by(id: repository_id, author: author)

    unless repository
      Rails.logger.error("Repository not found: author-#{author.id} repository-#{repository.id}")
      return
    end

    old_commit = repository.lookup(repository.commit_sha)
    new_commit = repository.lookup(commit_sha)
    diff = old_commit.diff(new_commit)
    @blobs ||= Git::Blob.all(repository, commit_sha)

    diff.deltas.each do |delta|
      next unless FasterPath.extname(delta.new_file[:path] || delta.old_file[:path]).end_with?('.md')
      git_blob = @blobs.find { |blob| blob.id == delta.new_file[:oid] }

      case delta.status
      when :added, :modified, :renamed
        create_or_update(git_blob) if git_blob
      when :deleted
        repository.posts.find_by(repository: repository, blob_path: delta.old_file[:path])&.destroy
      end
    end

    sync_images

    if repository.update(commit_sha: commit_sha)
      Rails.logger.error("Repository sync success: commit-#{commit_sha} author-#{author.id} repository-#{repository.id}")
    else
      Rails.logger.error("Repository sync failed: commit-#{commit_sha} author-#{author.id} repository-#{repository.id}")
    end
  end

  private

  def sync_images
    @blobs.each do |blob|
      next if FasterPath.extname(blob.path).end_with?('.md')

      if MimeMagic.by_magic(blob.io)&.image?
        path = File.join(Rails.root, 'public', 'uploads', author.nickname)
        subdirectory, filename = FasterPath.chop_basename(blob.path)

        if subdirectory
          path_with_subdirectory = File.join(path, subdirectory)
          FileUtils.mkdir_p(path_with_subdirectory) unless File.exists?(path_with_subdirectory)
        end

        File.open(File.join(path_with_subdirectory, filename), 'wb') do |file|
          file.write(blob.io.read)
        end
      end
    end
  end

  def create_or_update(git_blob)
    post = repository.posts.find_or_initialize_by(repository: repository, blob_path: git_blob.path)
    post.assign_attributes(blob_path: git_blob.path, author: author)
    post.save
  end
end
