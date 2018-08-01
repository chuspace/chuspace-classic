# frozen_string_literal: true

class Mutations::CreateMagicLogin < ApplicationMutation
  argument :auth_token, String, required: true
  field :user, Types::UserType, null: true

  def resolve(**inputs)
    user = User.find_by(auth_token: params[:token])

    if user
      user.regenerate_auth_token
      login(user) if user
    end

    { user: user }
  end
end
