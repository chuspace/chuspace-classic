# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :find_user, only: :show

  def show
    @posts = @user.posts.includes(:blog, :author).limit(20)
  end

  def update
    if Current.user.update(update_params)
      flash[:notice] = 'Profile successfully updated'
    else
      flast[:notice] = 'Something went wrong'
    end

    redirect_to settings_profiles_path
  end

  private

  def update_params
    params.require(:user).permit(:email, :name, :bio, :url, :location, :company, :avatar)
  end

  def find_user
    @user = User.find_by(nickname: params[:nickname])
  end
end
