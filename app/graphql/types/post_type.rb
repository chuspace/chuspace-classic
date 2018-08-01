# frozen_string_literal: true

class Types::Api::PostType < ApplicationObject
  field :title, String, null: false
  field :slug, String, null: false
  field :body, String, null: false
  field :user, Types::Api::UserType, null: false
end
