# typed: ignore
# frozen_string_literal: true

class UserDraftsController < ApplicationController
  before_action :find_user
  layout 'user'

  def index
    @drafts = @user.posts.draft.includes(author: :repository).limit(20).order(id: :desc)
  end

  private

  def find_user
    @user = User.find_by(nickname: params[:user_nickname])
  end
end
