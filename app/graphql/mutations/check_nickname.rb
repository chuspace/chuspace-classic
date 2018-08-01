# frozen_string_literal: true

class Mutations::CheckNickname < ApplicationMutation
  field :user, Types::UserType, null: false
  argument :nickname, String, required: true

  def resolve(**inputs)
    user = User.find_by(nickname: inputs[:nickname])

    if user
      { user: user, errors: { nickname: I18n.t('.check_nickname.taken', nickname: params[:nickname]) } }
    else
      new_user = User.new(nickname: params[:nickname])
      if new_user.valid_attributes?(:nickname)
        { user: new_user }
      else
        { user: new_user, errors: new_user.api_validation_errors }
      end
    end
  end
end
