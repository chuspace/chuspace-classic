# frozen_string_literal: true

class Mutations::CreateLogin < ApplicationMutation
  argument :email, String, 'Email of the user', required: true
  field :user, Types::UserType, 'User associated with the email', null: true

  def resolve(**inputs)
    user = User.find_by(email: inputs[:email])

    if user
      UserMailer.with(user: user).send_magic_login.deliver_later
      { user: user }
    else
      { errors: { email: I18n.t('.create_login.not_found') } }
    end
  end
end
