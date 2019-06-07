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

    blobs = Git::Blob.all(repository, repository.head.target.oid)

    blobs.each do |git_blob|
      mime_type = Shrine.determine_mime_type(git_blob.io)

      if mime_type.include?('image')
        image = repository.images.find_or_initialize_by(repository: repository, path: git_blob.path)
        image.assign_attributes(blob_path: git_blob.path, image: git_blob.io)
        image.save
      elsif mime_type.include?('text')
        post = repository.posts.find_or_initialize_by(repository: repository, path: git_blob.path)
        post.assign_attributes(blob_path: git_blob.path, author: author)
        post.save
      else
        Rails.logger.error("Repository invalid mime: mime-#{mime_type} commit-#{commit_sha} author-#{author.id} repository-#{repository.id}")
      end
    end

    if repository.update(commit_sha: commit_sha)
      Rails.logger.error("Repository sync success: commit-#{commit_sha} author-#{author.id} repository-#{repository.id}")
    else
      Rails.logger.error("Repository sync failed: commit-#{commit_sha} author-#{author.id} repository-#{repository.id}")
    end
  end
end
