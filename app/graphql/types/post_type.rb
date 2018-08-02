# frozen_string_literal: true

class Types::PostType < ApplicationObject
  description 'Exposes post model fields'

  field :title, String, 'The title of the post', null: false
  field :slug, String, 'The unique slug of the post', null: false
  field :body, String, 'The body of the post', null: false
  field :user, Types::UserType, 'The user associated with the post', null: false
end
