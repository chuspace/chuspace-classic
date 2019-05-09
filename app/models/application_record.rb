# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def api_validation_errors
    errors.map { |error| { field: error.attribute, errors: error.full_message } }.freeze
  end

  def api_validation_errors_sentence
    errors.map { |error| error.full_message }.to_sentence
  end

  def valid_attributes?(*attributes)
    attributes.each do |attribute|
      self.class.validators_on(attribute).each { |validator| validator.validate_each(self, attribute, send(attribute)) }
    end

    errors.empty?
  end
end
