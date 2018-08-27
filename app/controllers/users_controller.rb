# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :find_user, except: %i[index]

  def show
  end

  def create
    user = User.new(user_params)

    if user.valid? && user.save
      Git::CreateRepo.call(user: user)
      UserMailer.with(user: user).send_magic_login.deliver_later

      render json: { success: t('.registration.success') }
    else
      render json: { errors: user.api_validation_errors }
    end
  end

  private
    def user_params
      params.require(:user).permit(:email, :name, :nickname)
    end

    def find_user
      @user = User.find_by(nickname: params[:nickname])
    end
end
