# frozen_string_literal: true

class Types::Api::ViewerType < Types::Base::Object
  field :current_user, Types::Api::UserType, null: false

  def current_user
    Current.user.presence
  end
end
