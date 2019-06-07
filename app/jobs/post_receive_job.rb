# frozen_string_literal: true

class PostReceiveJob < ApplicationJob
  queue_as :critical

  def perform(author_id:, repository_id:, commit_sha:)
    author = User.find_by(id: author_id)
    repository = Repository.find_by(id: repository_id, author: author)

    unless repository
      Rails.logger.error("Repository not found: author-#{author.id} repository-#{repository.id}")
      return
    end

    if commit_sha == repository.commit_sha
      Rails.logger.error("Everything up to date: author-#{author.id} repository-#{repository.id}")
      return
    end

    old_rugged_commit = repository.commit
    new_rugged_commit = repository.lookup(commit_sha)
    diff = old_rugged_commit.diff(new_rugged_commit)
    blobs ||= Git::Blob.all(repository, commit_sha)

    diff&.deltas&.each do |delta|
      git_blob = blobs.find { |blob| blob.id == delta.new_file[:oid] }

      case delta.status
      when :added, :renamed
        blob = repository.blobs.create(blob: git_blob.io, path: git_blob.path)
        next unless git_blob.binary?

        blob.create_post(repository: repository, author: author)
      when :modified
        blob = repository.blobs.find_by(path: File.join('/', delta.old_file[:path]))
        blob.update(blob: git_blob.io, path: git_blob.path)
      when :deleted
        repository.blobs.find_by(path: File.join('/', delta.old_file[:path]))&.destroy
      end
    end

    if repository.update(commit_sha: commit_sha)
      Rails.logger.error("Repository sync success: commit-#{commit_sha} author-#{author.id} repository-#{repository.id}")
    else
      Rails.logger.error("Repository sync failed: commit-#{commit_sha} author-#{author.id} repository-#{repository.id}")
    end
  end
end
