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

    Post.sync_from_repo(author: author, repository: repository, commit_sha: commit_sha)
  end
end
