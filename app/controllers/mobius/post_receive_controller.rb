# typed: ignore
# frozen_string_literal: true

module Mobius
  class PostReceiveController < BaseController
    def create
      PostReceiveJob.perform_later(
        author_id: params[:author_id], repository_id: params[:repository_id], commit_sha: params[:commit_sha]
      )

      self.status = 200
    end
  end
end
