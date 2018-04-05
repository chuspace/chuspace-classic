# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :authenticate, on: :create

  def create
    user = User.find_by(login_token: params[:token])
    login(user) if user
    redirect_to '/'
  end

  def github
  end

  def destroy
    logout
  end

  private
    def auth_hash
      request.env['omniauth.auth']
    end
end
