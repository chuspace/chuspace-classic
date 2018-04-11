# frozen_string_literal: true

module Resolvers
  module Repos
    class CreateResolver < ApplicationResolver
      def call
        response = Current.user.github_client.create_repo(params[:name], github_repo_params)
        repo = Current.user.build_repo(repo_params)
        repo.github_repo_id = response.id
        repo.github_repo_full_name = response.full_name

        if repo.save
          { repo: repo, viewer: viewer }
        else
          Current.user.github_client.delete_repo(response.id)
          { errors: repo.graphql_validation_errors }
        end

      rescue Octokit::UnprocessableEntity => e
        error_message_for(e.errors.first[:field], e.errors.first[:message])
      end

      private
        def repo_params
          params.permit(:name, :description)
        end

        def github_repo_params
          params.permit(:description, :organization, :license, :private, :auto_init)
        end
    end
  end
end
