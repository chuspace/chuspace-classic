# frozen_string_literal: true

class MagicLoginsController < ApplicationController
  skip_before_action :authenticate

  def index
    user = User.find_by(auth_token: params[:token])

    if user
      user.regenerate_auth_token
      login(user) if user
    end

    redirect_to root_path
  end
end
