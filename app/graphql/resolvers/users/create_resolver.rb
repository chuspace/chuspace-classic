# frozen_string_literal: true

class Resolvers::Users::CreateResolver < Resolvers::ApplicationResolver
  def call
    user = User.new(user_params)

    if user.valid? && user.save
      UserMailer.with(user: user).send_magic_login.deliver_later
      { user: user }
    else
      { errors: user.graphql_validation_errors }
    end
  end

  private
    def user_params
      params.permit(:name, :nickname, :email)
    end
end
