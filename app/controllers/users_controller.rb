# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :find_user, only: :show

  def show
    @posts = @user.posts.includes(:author).limit(20)
  end

  def create
    User.transaction do
      @user = User.new(create_params)
      @invite = Invite.find_by(code: params[:code])

      if @invite.may_accept? && @user.save
        @invite.user = @user
        @invite.accept!
        LoginMailer.with(user: @user).send_magic_login.deliver_later
        redirect_to root_path, notice: t('users.create.success')
      else
        render 'signups/index'
      end
    end
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

  def create_params
    params.require(:user).permit(:email, :name, :nickname)
  end

  def update_params
    params.require(:user).permit(:email, :name, :bio, :url, :location, :company, :avatar)
  end

  def find_user
    @user = User.find_by(nickname: params[:nickname]) || Current.user
  end
end
