# frozen_string_literal: true

class Types::PostType < ApplicationObject
  field :title, String, null: false
  field :slug, String, null: false
  field :body, String, null: false
  field :user, Types::UserType, null: false
end
