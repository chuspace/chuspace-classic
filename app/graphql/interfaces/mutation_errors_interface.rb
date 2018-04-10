# frozen_string_literal: true

Interfaces::MutationErrorsInterface = GraphQL::InterfaceType.define do
  name 'MutationErrors'
  field :errors, types[Types::ValidationErrorType], 'Returns validation errors (if any)'
end
