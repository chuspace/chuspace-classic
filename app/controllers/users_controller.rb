# frozen_string_literal: true

class UsersController < ApplicationController
  def create
    user = User.new(user_params)

    if user.valid? && user.save
      UserMailer.with(user: user).send_magic_login.deliver_later
      render json: { id: user.id }
    else
      render json: { errors: user.errors.messages }, status: 422
    end
  end

  def show
  end

  private
    def find_user
      @user = User.find_by(nickname: params[:nickname])
    end

    def user_params
      params.permit(:name, :nickname, :email)
    end
end
