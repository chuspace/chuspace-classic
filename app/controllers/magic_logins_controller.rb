# frozen_string_literal: true

class MagicLoginsController < ApplicationController
  def index
    user = User.find_by(auth_token: params[:token])

    if user
      login(user)
      user.regenerate_auth_token
    end

    redirect_to root_path
  end
end
