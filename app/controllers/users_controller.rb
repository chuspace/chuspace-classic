# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :find_user, only: :show

  def show
    @posts = @user.posts.includes(:blog, :author).limit(20)
  end

  def create
    @user = User.new(create_params)
    @invite = Invite.find_by(code: params[:code])
    @user.build_default_blog(author: @user, name: @user.name, slug: @user.nickname, default: true)

    if @invite.may_accept? && @user.save
      @invite.accept!
      LoginMailer.with(user: @user).send_magic_login.deliver_later
      redirect_to root_path, notice: t('.signup.success')
    else
      render 'signups/index'
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
