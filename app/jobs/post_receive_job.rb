# typed: ignore
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

    author.transaction do
      old_commit = repository.lookup(repository.commit_sha)
      new_commit = repository.lookup(commit_sha)
      diff = old_commit.diff(new_commit).find_similar!(all: true)
      blobs ||= Git::Blob.all(repository, commit_sha)

      diff.deltas.each do |delta|
        next unless FasterPath.extname(delta.new_file[:path] || delta.old_file[:path]).end_with?('.md')
        git_blob = blobs.find { |blob| blob.id == delta.new_file[:oid] }

        case delta.status
        when :added, :modified
          post = author.posts.find_or_initialize_by(blob_path: git_blob.path)
          next_post_id = author.posts.maximum(:id)&.next || 1

          post.assign_attributes(slug: git_blob.id[0..8]) if post.new_record?
          post.save
        when :renamed
          author.posts.find_by(blob_path: delta.old_file[:path])&.update(blob_path: delta.new_file[:path])
        when :deleted
          author.posts.find_by(blob_path: delta.old_file[:path])&.destroy
        end
      end

      if repository.update(commit_sha: commit_sha)
        Rails.logger.error(
          "Repository sync success: commit-#{commit_sha} author-#{author.id} repository-#{repository.id}"
        )
      else
        Rails.logger.error(
          "Repository sync failed: commit-#{commit_sha} author-#{author.id} repository-#{repository.id}"
        )
      end
    end
  end
end
