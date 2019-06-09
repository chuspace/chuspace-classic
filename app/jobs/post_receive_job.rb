# frozen_string_literal: true

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
    blobs ||= Git::Blob.all(repository, commit_sha)

    diff.deltas.each do |delta|
      git_blob = blobs.find { |blob| blob.id == delta.new_file[:oid] }
      type = case FasterPath.extname(git_blob&.path || delta.old_file[:path])
             when '.md' then 'post'
             when '.png', '.jpg', '.gif', '.jpeg' then 'image'
      end

      case delta.status
      when :added, :modified, :renamed
        create_or_update(git_blob, type) if git_blob
      when :deleted
        case type
        when 'post'
          repository.posts.find_by(repository: repository, blob_path: delta.old_file[:path])&.destroy
        when 'image'
          repository.images.find_by(repository: repository, blob_path: delta.old_file[:path])&.destroy
        end
      end
    end

    if repository.update(commit_sha: commit_sha)
      Rails.logger.error("Repository sync success: commit-#{commit_sha} author-#{author.id} repository-#{repository.id}")
    else
      Rails.logger.error("Repository sync failed: commit-#{commit_sha} author-#{author.id} repository-#{repository.id}")
    end
  end

  private

  def create_or_update(git_blob, type)
    case type
    when 'image'
      image = repository.images.find_or_initialize_by(repository: repository, blob_path: git_blob.path)
      image.assign_attributes(blob_path: git_blob.path, image: git_blob.io)
      image.save
    when 'post'
      post = repository.posts.find_or_initialize_by(repository: repository, blob_path: git_blob.path)
      post.assign_attributes(blob_path: git_blob.path, author: author)
      post.save
    else
      Rails.logger.error("Repository unknown type: #{type} commit-#{commit_sha} author-#{author.id} repository-#{repository.id}")
    end
  end
end
