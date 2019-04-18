# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :redirect_if_signedin, except: :destroy

  def index; end

  def create
    user = User.find_by(email: params[:email])

    if user
      LoginMailer.with(user: user).send_magic_login.deliver_later
      render json: { success: t('.login.success') }
    else
      render json: { errors: errors_for(:email, t('.login.email_not_found')) }
    end
  end

  def destroy
    logout
    redirect_to root_path
  end

  private

  def redirect_if_signedin
    redirect_back(fallback_location: root_path) if Current.user.present?
  end
end
