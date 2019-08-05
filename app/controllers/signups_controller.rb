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

      respond_to do |format|
        if @user.save
          @user.create_repository
          UserMailer.with(user: @user).welcome.deliver_later
          format.html { redirect_to root_path, notice: t('users.create.success') }
        else
          format.js
          format.html { redirect_to root_path, notice: @user.errors.full_messages.to_sentence }
        end
      end
    end
  end

  private

  def create_params
    params.require(:user).permit(:email, :name, :nickname)
  end

  def redirect_if_registered
    redirect_back(fallback_location: root_path) if Current.user.present?
  end
end
