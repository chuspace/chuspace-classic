# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def api_validation_errors
    errors.messages.map do |field, errors|
      OpenStruct.new(field: field.to_s, messages: errors.to_sentence)
    end
  end

  def errors_for(field, message)
    [OpenStruct.new(field: field, messages: message)]
  end

  def valid_attributes?(*attributes)
    attributes.each do |attribute|
      self.class.validators_on(attribute).each do |validator|
        validator.validate_each(self, attribute, send(attribute))
      end
    end
    errors.none?
  end
end
