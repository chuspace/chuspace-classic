# frozen_string_literal: true

module Resolvers
  module Repos
    class CreateResolver < ApplicationResolver
      def call
        response = Current.user.github_client.create_repo(params[:name], github_repo_params)
        puts response.inspect
        repo = Current.user.create_repo!(repo_params)
        { repo: repo, viewer: viewer }
      end

      private
        def repo_params
          params.require(:repo).permit(:name, :description)
        end

        def github_repo_params
          params.require(:repo).permit(:description, :organization, :license, :private, :auto_init)
        end
    end
  end
end
