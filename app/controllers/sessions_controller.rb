# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :authenticate, on: %i[create github]

  def create
    user = User.find_by(auth_token: params[:token])
    login(user) if user
    redirect_to '/'
  end

  def github
    user = User.from_github(auth_hash)
    login(user) if user
    redirect_to '/'
  end

  def destroy
    logout
    redirect_to '/'
  end

  private
    def auth_hash
      request.env['omniauth.auth']
    end
end
