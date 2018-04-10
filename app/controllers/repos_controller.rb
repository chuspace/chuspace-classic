# frozen_string_literal: true

class ReposController < ApplicationController
  before_action :authenticate!

  def create
    if Current.user.github_client.create_repo(params[:name], github_repo_params)
      Current.user.create_repo!(repo_params)
      redirect_to root_url
    else
      redirect_to connect_repo_url
    end
  end

  private
    def repo_params
      params.require(:repo).permit(:name, :description)
    end

    def github_repo_params
      params.require(:repo).permit(:description, :organization, :license, :private, :auto_init)
    end
end
