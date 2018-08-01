# frozen_string_literal: true

class Mutations::Logins::Create < Mutations::Base::Mutation
  return_field :user, Types::Api::UserType

  input_field :inputs, !types.String

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
