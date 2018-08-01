# frozen_string_literal: true

class Types::Api::ViewerType < ApplicationObject
  field :current_user, Types::Api::UserType, null: false

  def current_user
    Current.user.presence
  end
end
