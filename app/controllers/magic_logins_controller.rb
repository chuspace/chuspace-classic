# frozen_string_literal: true

class MagicLoginsController < ApplicationController
  def index
    user = User.find_by(auth_token: params[:token])

    if user
      login(user)
      user.update_tracked_fields!(request)
      user.regenerate_auth_token

      redirect_to root_url
    else
      redirect_to sessions_url, notice: t('.magic_login.expired')
    end
  end
end
