# frozen_string_literal: true

Types::RepoType = GraphQL::ObjectType.define do
  name 'Repo'
  description 'Repo object'
  global_id_field :id

  field :name, types.String, 'Repo name'
  field :description, types.String, 'Repo description'
  field :slug, types.String, 'Repo slug identifier'
  field :user, Types::UserType, 'User associated with repo', preload: :user
end
