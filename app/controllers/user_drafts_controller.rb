# typed: ignore
# frozen_string_literal: true

class UserDraftsController < ApplicationController
  before_action :authenticate!, :find_user

  def index
    @publication = @user.publication
    @posts = @publication.posts.draft.includes(:author).limit(20).order(id: :desc)
    render 'users/show'
  end

  private

  def find_user
    @user = User.find_by(nickname: params[:user_nickname])
  end
end
