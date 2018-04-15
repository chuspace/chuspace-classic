# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :failure, only: :github, if: :malformed_auth?
  skip_before_action :authenticate, on: %i[create github]

  def create
    user = User.find_by(email: session_params[:email])

    if user
      UserMailer.with(user: user).send_magic_login.deliver_later
      render json: { id: user.id }.to_json
    else
      render json: { errors: { email: I18n.t('.create_login.not_found') } }, status: 422
    end
  end

  def github
    user = User.from_github(auth_hash)
    if user
      login(user) if user
      redirect_to root_path
    else
      failure
    end
  end

  def destroy
    logout
    redirect_to root_path
  end

  def failure
    redirect_to root_path
  end

  private
    def session_params
      params.require(:session).permit(:email)
    end

    def auth_hash
      request.env['omniauth.auth']
    end

    def malformed_auth?
      auth_hash.blank? ||
        auth_hash.credentials.blank? ||
        auth_hash.info.name.blank?
    end
end
