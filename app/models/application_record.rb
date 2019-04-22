# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def api_validation_errors
    errors.messages.map { |field, errors| { field: field, errors: errors.to_sentence } }.freeze
  end

  def valid_attributes?(*attributes)
    attributes.each do |attribute|
      self.class.validators_on(attribute).each { |validator| validator.validate_each(self, attribute, send(attribute)) }
    end
    errors.none?
  end
end
