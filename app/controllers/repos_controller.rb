# frozen_string_literal: true

class ReposController < ApplicationController
  before_action :authenticate!

  def new
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
      render json: { errors: repo.errors.messages }
    end

  rescue Octokit::UnprocessableEntity => e
    render json: { errors: e.errors }
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
