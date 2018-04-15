# frozen_string_literal: true

class CheckNicknamesController < ApplicationController
  skip_before_action :authenticate

  def create
    user = User.find_by(nickname: params[:nickname])

    if user
      render json: { errors: { nickname: I18n.t('.check_nickname.taken', nickname: params[:nickname]) } }, status: 422
    else
      new_user = User.new(nickname: params[:nickname])
      if new_user.valid_attributes?(:nickname)
        head :no_content
      else
        render json: { errors: new_user.api_validation_errors }, status: 422
      end
    end
  end
end
