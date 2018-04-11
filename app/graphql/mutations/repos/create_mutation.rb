# frozen_string_literal: true

Mutations::Repos::CreateMutation = GraphQL::Relay::Mutation.define do
  name 'Create Repo'
  description 'Creates a new repo'

  input_field :name, !types.String, 'Repo name e.g. foobar'
  input_field :description, types.String, 'Repo description e.g. some description'
  input_field :organization, types.String, 'Org name e.g. Acme'
  input_field :license, types.String, 'License e.g. MIT'
  input_field :private, types.String, 'Is this a private repo? e.g. true'
  input_field :auto_init, types.String, 'Should initialize a readme? e.g. true'

  return_field :viewer, Types::ViewerType
  return_field :repo, Types::RepoType
  return_interfaces [Interfaces::MutationErrorsInterface]

  resolve(Resolvers::Repos::CreateResolver)
end
