# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :find_user, except: %i[index]

  def show
  end

  def create
    user = User.new(inputs)

    if user.valid? && user.save
      Git::CreateAndStoreRepo.call(user: user)
      UserMailer.with(user: user).send_magic_login.deliver_later
      redirect_to root_path
    else
      render json: { errors: user.graphql_validation_errors, user: nil }
    end
  end

  private
    def find_user
      @user = User.find_by(nickname: params[:nickname])
    end
end
