# frozen_string_literal: true

class ReposController < ApplicationController
  before_action :authenticate!

  def new
    @repo = Repo.new(user: Current.user)
    @owners = Current.user.github_orgs
    render component: 'new-repo/index',
           props: { owners: @owners, repos_path: repos_path },
           prerender: false
  end

  def create
    github_params[:homepage] = user_url(Current.user) if Rails.env.production?
    response = Current.user.github_client.create_repo(name, github_params)
    repo = Current.user.build_repo(repo_params)
    repo.github_repo_id = response.id
    repo.github_repo_full_name = response.full_name

    if repo.save
      render json: { id: repo.id }
    else
      Current.user.github_client.delete_repo(response.id)
      render json: { errors: repo.api_validation_errors }, status: 422
    end

  rescue Octokit::UnprocessableEntity => e
    render json: { errors: parse_api_errors(e.errors) }, status: 422
  end

  private
    def name
      params[:name]&.parameterize
    end

    def repo_params
      params.permit(:name, :description, :owner)
    end

    def github_params
      params.permit(:description, :organization)
    end
end
