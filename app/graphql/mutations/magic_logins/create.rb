# frozen_string_literal: true

class Mutations::MagicLogins::Create < ApplicationMutation
  return_field :user, Types::Api::UserType
  input_field :auth_token, !types.String

  def resolve(**inputs)
    user = User.find_by(auth_token: params[:token])

    if user
      user.regenerate_auth_token
      login(user) if user
    end
  end
end
