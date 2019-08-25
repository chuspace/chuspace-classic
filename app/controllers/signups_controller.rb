# typed: ignore
# frozen_string_literal: true

class SignupsController < ApplicationController
  before_action :redirect_if_registered

  def index
    @user = User.new
  end

  def create
    User.transaction do
      @user = User.new(create_params)
      @user.auth_token_expires_at = User::AUTH_TOKEN_LIFE.minutes.from_now

      respond_to do |format|
        if @user.save
          UserMailer.with(user: @user).welcome.deliver_later
          format.html { redirect_to root_path, notice: t('users.create.success') }
        else
          format.js
          format.html { redirect_to root_path, notice: @user.errors.messages.to_sentence }
        end
      end
    end
  end

  private

  def create_params
    params.require(:signup).permit(:email, :name, :nickname)
  end

  def redirect_if_registered
    redirect_to(root_path) && return if Current.user.present?
  end
end
