# typed: false
# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def api_validation_errors
    errors.full_messages.to_sentence
  end

  def api_validation_errors_sentence
    errors.full_messages.to_sentence
  end

  def valid_attributes?(*attributes)
    attributes.each do |attribute|
      self.class.validators_on(attribute).each { |validator| validator.validate_each(self, attribute, send(attribute)) }
    end

    errors.empty?
  end
end
