# frozen_string_literal: true

class MagicLoginsController < ApplicationController
  def index
    user = User.find_by(auth_token: inputs[:auth_token])
    if user
      user.regenerate_auth_token
      login
    end
    redirect_to root_path
  end
end
