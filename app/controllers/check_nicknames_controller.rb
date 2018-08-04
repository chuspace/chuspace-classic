# frozen_string_literal: true

class CheckNicknamesController < ApplicationController
  def index
    user = User.find_by(nickname: inputs[:nickname])

    if user
      { available: false, errors: user.errors_for(:nickname, I18n.t('.check_nickname.taken', nickname: inputs[:nickname])) }
    else
      new_user = User.new(nickname: inputs[:nickname])

      if new_user.valid_attributes?(:nickname)
        { available: true }
      else
        { available: false, errors: new_user.api_errors }
      end
    end
  end
end
