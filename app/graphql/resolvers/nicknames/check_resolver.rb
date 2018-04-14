# frozen_string_literal: true

class Resolvers::Nicknames::CheckResolver < Resolvers::ApplicationResolver
  def call
    user = User.find_by(nickname: params[:nickname])

    if user
      error_message_for(:nickname, I18n.t('.check_nickname.taken', nickname: params[:nickname]))
    else
      new_user = User.new(nickname: params[:nickname])
      new_user.valid_attributes?(:nickname)
      { errors: new_user.graphql_validation_errors }
    end
  end
end
