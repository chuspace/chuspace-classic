# frozen_string_literal: true

module Mobius
  class PreReceiveController < BaseController
    def create
      puts params.inspect
      author = User.find_by(id: params[:author_id])
      repository = Repository.find_by(id: params[:repository_id], author: author)

      unless repository
        self.status = 404
        self.response_body = 'Repository not found'
        Rails.logger.error("Repository not found: author-#{author.id} repository-#{repository.id}")
        return
      end

      post = Post.find_or_initialize_from_blob(
        author: author,
        repository: repository,
        blob: params[:blob],
        blob_name: params[:blob_name]
      )

      if post.valid?
        self.status = 200
      else
        self.status = 422
        self.response_body = post.errors.full_messages.to_sentence
      end

    rescue ActiveModel::UnknownAttributeError => ex
      self.response_body = ex.message
    end
  end
end
