class Mutations::Users::Create < GraphQL::Schema::RelayClassicMutation
  return_field :user, Types::Api::UserType

  input_field :name, !types.String
  input_field :nickname, !types.String
  input_field :email, !types.String

  def resolve(**inputs)
    user = User.new(inputs)

    if user.valid? && user.save
      UserMailer.with(user: user).send_magic_login.deliver_later
      { user: user }
    else
      { errors: user.api_validation_errors, user: nil }
    end
  end
end
