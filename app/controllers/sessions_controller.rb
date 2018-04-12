# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :failure, only: :github, if: :malformed_auth?

  def create
    if Current.user.present?
      redirect_to root_path
    else
      user = User.find_by(auth_token: params[:token])
      if user
        user.regenerate_auth_token
        login(user)
        redirect_to root_path
      else
        failure
      end
    end
  end

  def github
    if Current.user.present?
      redirect_to root_path
    else
      user = User.from_github(auth_hash)
      if user
        login(user)
        redirect_to root_path
      else
        failure
      end
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
    def auth_hash
      request.env['omniauth.auth']
    end

    def malformed_auth?
      auth_hash.blank? ||
        auth_hash.credentials.blank? ||
        auth_hash.info.name.blank?
    end
end
