# frozen_string_literal: true

module Resolvers
  module Repos
    class CreateResolver < ApplicationResolver
      include Rails.application.routes.url_helpers

      def call
        github_params[:homepage] = user_url(Current.user) if Rails.env.production?
        response = Current.user.github_client.create_repo(name, github_params)

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
        def name
          params[:name]&.parameterize
        end

        def repo_params
          params.permit(:name, :description)
        end

        def github_params
          params.permit(:description, :organization, :license, :private, :auto_init)
        end
    end
  end
end
