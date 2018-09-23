# frozen_string_literal: true

class CheckNicknamesController < ApplicationController
  def index
    person = Person.find_by(nickname: inputs[:nickname])

    if person
      { available: false, errors: person.errors_for(:nickname, t('.check_nickname.taken', nickname: inputs[:nickname])) }
    else
      new_person = Person.new(nickname: inputs[:nickname])

      if new_person.valid_attributes?(:nickname)
        { available: true }
      else
        { available: false, errors: new_person.api_errors }
      end
    end
  end
end
