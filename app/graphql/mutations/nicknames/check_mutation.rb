# frozen_string_literal: true

Mutations::Nicknames::CheckMutation = GraphQL::Relay::Mutation.define do
  name 'CheckNickname'
  description 'Checks if a nickname is present in the system'

  input_field :nickname, types.String, 'User nickname e.g. foobar'
  return_interfaces [Interfaces::MutationErrorsInterface]

  resolve(Resolvers::Nicknames::CheckResolver)
end
