# frozen_string_literal: true

class Types::UserType < ApplicationObject
  include Rails.application.routes.url_helpers

  description 'Exposes user model fields'

  field :name, String, 'The name of the user', null: false
  field :nickname, String, 'The unique nickname of the user', null: false
  field :github_nickname, String, 'The github nickname of the user', null: false
  field :bio, String, 'The bio of the user', null: true
  field :company, String, 'The company of the user', null: false

  field :avatar_url, String, 'The avatar url of the user', null: false do
    argument :width, Integer, required: false, default_value: 100
    argument :height, Integer, required: false, default_value: 100
  end

  def avatar_url(width:, height:)
    url_for(object.avatar.variant(resize_to_fit: [width, height]))
  end
end
