# frozen_string_literal: true

Mutations::Users::CreateMutation = GraphQL::Relay::Mutation.define do
  name 'CreateUser'
  description 'Creates a new user'

  input_field :name, !types.String, 'User name eg: John Doe'
  input_field :nickname, !types.String, 'User nickname e.g. johndoe'
  input_field :email, types.String, 'User email e.g. john@doe.com'

  return_field :user, Types::UserType
  return_interfaces [Interfaces::MutationErrorsInterface]

  resolve(Resolvers::Users::CreateResolver)
end
