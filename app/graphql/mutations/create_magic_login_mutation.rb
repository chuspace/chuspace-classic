# frozen_string_literal: true

class Mutations::CreateMagicLoginMutation < ApplicationMutation
  argument :auth_token, String, 'Auth token for a user', required: true
  field :user, Types::UserType, 'User associated with auth token', null: true

  def resolve(**inputs)
    user = User.find_by(auth_token: params[:token])

    if user
      user.regenerate_auth_token
      login(user) if user
    end

    { user: user }
  end
end
