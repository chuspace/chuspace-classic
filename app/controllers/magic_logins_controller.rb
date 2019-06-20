# typed: true
# frozen_string_literal: true

class MagicLoginsController < ApplicationController
  def index
    user = User.find_by(auth_token: params[:token])

    if user
      login(user)
      redirect_to root_url
    else
      redirect_to signins_url, notice: t('.magic_login.expired')
    end
  end
end
