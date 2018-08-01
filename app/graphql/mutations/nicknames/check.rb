# frozen_string_literal: true

class Mutations::Nicknames::Check < Mutations::Base::Mutation
  return_field :user, Types::Api::UserType
  input_field :nickname, !types.String

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
