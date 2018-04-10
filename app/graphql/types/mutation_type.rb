# frozen_string_literal: true

Types::MutationType = GraphQL::ObjectType.define do
  name 'Mutation'
  description 'The query root of this schema for mutating data.'

  # TODO: Remove me
  field :testField, types.String do
    description 'An example field added by the generator'
    resolve ->(obj, args, ctx) {
      'Hello World!'
    }
  end
end
