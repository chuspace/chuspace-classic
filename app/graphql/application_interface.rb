# frozen_string_literal: true

module ApplicationInterface
  include GraphQL::Schema::Interface
  field :errors, [Types::ValidationErrorType], null: true
end
