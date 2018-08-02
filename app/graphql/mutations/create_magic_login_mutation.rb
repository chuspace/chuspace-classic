# frozen_string_literal: true

class Mutations::CreateMagicLoginMutation < ApplicationMutation
  argument :auth_token, String, 'Auth token for a user', required: true
  field :user, Types::UserType, 'User associated with auth token', null: true

  def resolve(**inputs)
    user = User.find_by(auth_token: inputs[:auth_token])

    if user
      user.regenerate_auth_token
      context[:cookies].encrypted[:user_id] = { value: user.id, expires: 1.year.from_now } if user
    end

    { user: user }
  end
end
