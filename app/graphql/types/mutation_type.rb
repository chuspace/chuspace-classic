# frozen_string_literal: true

Types::MutationType = GraphQL::ObjectType.define do
  name 'Mutation'
  description 'The query root of this schema for mutating data.'

  field :create_repo, field: Mutations::Repos::CreateMutation.field
end
