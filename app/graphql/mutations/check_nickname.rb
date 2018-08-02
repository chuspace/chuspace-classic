# frozen_string_literal: true

class Mutations::CheckNickname < ApplicationMutation
  field :available, Boolean, 'Returns if the nickname is available', null: false
  argument :nickname, String, 'Nickname of the user',  required: true

  def resolve(**inputs)
    user = User.find_by(nickname: inputs[:nickname])

    if user
      { available: false, errors: user.errors_for(:nickname, I18n.t('.check_nickname.taken', nickname: inputs[:nickname])) }
    else
      new_user = User.new(nickname: inputs[:nickname])


      if new_user.valid_attributes?(:nickname)
        { available: true }
      else
        { available: false, errors: new_user.graphql_validation_errors }
      end
    end
  end
end
