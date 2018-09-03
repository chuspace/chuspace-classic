# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :find_user, only: :show

  def show
  end

  def create
    user = User.new(create_params)

    if user.valid? && user.save
      Git::CreateRepo.call(user: user)
      UserMailer.with(user: user).send_magic_login.deliver_later

      render json: { success: t('.registration.success') }
    else
      render json: { errors: user.api_validation_errors }
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
    params.require(:user).permit(:email, :name, :bio, :url, :location, :company)
  end

  def find_user
    @user = User.find_by(nickname: params[:nickname])
  end
end
