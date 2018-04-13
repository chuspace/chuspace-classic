# frozen_string_literal: true

class Resolvers::Logins::CreateResolver < Resolvers::ApplicationResolver
  def call
    user = User.find_by(email: params[:email])

    if user
      UserMailer.with(user: user).send_magic_login.deliver_later
      { user: user }
    else
      { errors: user.graphql_validation_errors }
    end
  end
end
