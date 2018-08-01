# frozen_string_literal: true

class Types::Api::UserType < Types::Base::Object
  include Rails.application.routes.url_helpers

  field :name, String, null: false
  field :nickname, String, null: false
  field :github_nickname, String, null: false
  field :bio, String, null: false
  field :company, String, null: false

  field :avatar_url, String, null: false do
    argument :width, Integer, required: false, default_value: 100
    argument :height, Integer, required: false, default_value: 100
  end

  def avatar_url(width:, height:)
    url_for(object.avatar.variant(resize_to_fit: [width, height]))
  end
end
