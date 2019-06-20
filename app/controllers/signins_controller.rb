# typed: true
# frozen_string_literal: true

class SigninsController < ApplicationController
  before_action :redirect_if_signedin, except: :destroy

  def index
    @user = User.new
  end

  def create
    @user = User.find_by(email: signin_params[:email])

    if @user
      LoginMailer.with(user: @user).send_magic_login.deliver_later
      redirect_to signins_path, notice: t('signins.create.success')
    else
      @user = User.new(email: signin_params[:email])
      @user.errors.add(:email, t('signins.create.failure'))
      render :index
    end
  end

  def destroy
    logout
    redirect_to root_path
  end

  private

  def signin_params
    params.require(:user).permit(:email)
  end

  def redirect_if_signedin
    redirect_back(fallback_location: root_path) if Current.user.present?
  end
end
