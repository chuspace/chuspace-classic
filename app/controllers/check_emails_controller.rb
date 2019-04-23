# frozen_string_literal: true

class CheckEmailsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])

    if user
      render json: { available: false, errors: errors_for(:email, t('.check_email.taken', email: params[:email])) },
             status: :unprocessable_entity
    else
      new_user = User.new(email: params[:email])

      if new_user.valid_attributes?(:email)
        render json: { available: true }
      else
        render json: { available: false, errors: new_user.api_validation_errors }, status: :unprocessable_entity
      end
    end
  end
end
