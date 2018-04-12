# frozen_string_literal: true

Mutations::Logins::CreateMutation = GraphQL::Relay::Mutation.define do
  name 'CreateLogin'
  description 'Creates and sends a new user login link'

  input_field :email, types.String, 'User email e.g. john@doe.com'
  return_field :user, Types::UserType
  return_interfaces [Interfaces::MutationErrorsInterface]

  resolve(Resolvers::Logins::CreateResolver)
end
