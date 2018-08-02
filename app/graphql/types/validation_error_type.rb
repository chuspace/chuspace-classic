# frozen_string_literal: true

class Types::ValidationErrorType < ApplicationObject
  description 'Exposes active record validation errors'

  field :field, String, 'The name of the field', null: false
  field :messages, String, 'Validation error message', null: false
end
