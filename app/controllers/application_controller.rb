# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Authentication
  include SetCurrentRequestDetails
  per_request_react_rails_prerenderer

  private
    def error_message_for(field, message, options = {})
      { errors: [OpenStruct.new(field: field, messages: [message])], **options }
    end
end
