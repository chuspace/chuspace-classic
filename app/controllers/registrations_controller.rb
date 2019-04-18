# frozen_string_literal: true

class RegistrationsController < ApplicationController
  before_action :redirect_if_registered

  def index; end

  def create
    user = User.new(create_params)

    if user.save
      LoginMailer.with(user: user).send_magic_login.deliver_later
      render json: { success: t('.registration.success') }
    else
      render json: { errors: user.api_validation_errors }
    end
  end

  private

  def redirect_if_registered
    redirect_back(fallback_location: root_path) if Current.user.present?
  end

  def create_params
    params.require(:user).permit(:email, :name, :nickname, default_blog_attributes: %i[name])
  end
end
