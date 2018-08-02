class Types::ValidationErrorType < ApplicationObject
  description 'Exposes active record validation errors'

  field :field, String, null: false
  field :messages, String, null: false
end
