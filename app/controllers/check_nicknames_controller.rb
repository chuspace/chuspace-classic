# frozen_string_literal: true

class CheckNicknamesController < ApplicationController
  def create
    person = Person.find_by(nickname: params[:nickname])

    if person
      render json: { available: false, errors: errors_for(:nickname, t('.check_nickname.taken', nickname: params[:nickname])) }
    else
      new_person = Person.new(nickname: params[:nickname])

      if new_person.valid_attributes?(:nickname)
        render json: { available: true }
      else
        render json: { available: false, errors: new_person.api_validation_errors }
      end
    end
  end
end
