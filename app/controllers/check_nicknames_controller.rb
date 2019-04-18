# frozen_string_literal: true

class CheckNicknamesController < ApplicationController
  def create
    user = User.find_by(nickname: params[:nickname])

    if user
      render json: {
               available: false,
               errors:
                 errors_for(
                   :nickname,
                   t('.check_nickname.taken', nickname: params[:nickname])
                 )
             }
    else
      new_user = User.new(nickname: params[:nickname])

      if new_user.valid_attributes?(:nickname)
        render json: { available: true }
      else
        render json: {
                 available: false, errors: new_user.api_validation_errors
               }
      end
    end
  end
end
