# typed: ignore
# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :find_user, only: :show

  layout 'user'

  def show
    @posts = @user.posts.published.includes(:author).limit(20).order(id: :desc)
  end

  def update
    @user = Current.user
    @user.assign_attributes(update_params)

    if @user.save
      flash[:notice] = 'Profile successfully updated'
      redirect_to settings_profiles_path
    else
      @user = Current.user.reload
      render 'settings/profiles/index', layout: 'application'
    end
  end

  private

  def update_params
    params.require(:user).permit(:email, :name, :bio, :url, :location, :company, :avatar)
  end

  def find_user
    @user = User.find_by!(nickname: params[:nickname])
  end
end
