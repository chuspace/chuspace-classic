# frozen_string_literal: true

class Types::ViewerType < ApplicationObject
  description 'Exposes top level root fields for a viewer'

  field :current_user, Types::UserType, 'The current logged in user', null: false

  def current_user
    Current.user.presence
  end
end
