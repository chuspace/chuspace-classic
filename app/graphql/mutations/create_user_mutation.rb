# frozen_string_literal: true

class Mutations::CreateUserMutation < ApplicationMutation
  field :user, Types::UserType, 'New user', null: true

  argument :name, String, 'The name of the user', required: true
  argument :nickname, String, 'The unique nickname of the user', required: true
  argument :email, String, 'The unique email of the user', required: true

  def resolve(**inputs)
    user = User.new(inputs)

    if user.valid? && user.save
      Git::CreateAndStoreRepo.call(user: user)
      UserMailer.with(user: user).send_magic_login.deliver_later
      { user: user }
    else
      { errors: user.graphql_validation_errors, user: nil }
    end
  end
end
