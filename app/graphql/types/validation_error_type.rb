# frozen_string_literal: true

Types::ValidationErrorType = GraphQL::ObjectType.define do
  name 'ValidationError'
  description 'Exposes active record validation errors'

  field :field, types.String, 'Returns invalid field name'
  field :messages, types[types.String], 'Returns a list of validation errors'
end
