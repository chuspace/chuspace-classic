# frozen_string_literal: true

Types::UserType = GraphQL::ObjectType.define do
  name 'User'
  description 'Exposes user model fields'
  global_id_field :id

  field :name, types.String, 'User full name'
  field :email, types.String, 'User email'
  field :avatar_url, types.String, 'User avatar url'
  field :bio, types.String, 'User bio'
  field :nickname, !types.String, 'User nickname'
  field :website, !types.String, 'User website url'
  field :company, !types.String, 'User company'
  field :location, !types.String, 'User location'
end
