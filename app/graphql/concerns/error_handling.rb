# frozen_string_literal: true

module ErrorHandling
  extend ActiveSupport::Concern

  def parse_api_errors(errors)
    errors.each_with_object({}) do |error, hash|
      hash[error[:field]] = error[:message]
    end
  end

  def error_message_for(field, message, options = {})
    { errors: [OpenStruct.new(field: field, messages: [message])], **options }
  end
end
