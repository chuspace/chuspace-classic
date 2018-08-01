# frozen_string_literal: true

class Types::ViewerType < ApplicationObject
  field :current_user, Types::UserType, null: false

  def current_user
    Current.user.presence
  end
end
