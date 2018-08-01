# frozen_string_literal: true

class Mutations::CreateUser < ApplicationMutation
  field :user, Types::UserType, null: true

  argument :name, String, required: true
  argument :nickname, String, required: true
  argument :email, String, required: true

  def resolve(**inputs)
    user = User.new(inputs)

    if user.valid? && user.save
      Git::CreateAndStoreRepo.call(user: user)
      UserMailer.with(user: user).send_magic_login.deliver_later
      { user: user }
    else
      { errors: user.api_validation_errors, user: nil }
    end
  end
end
