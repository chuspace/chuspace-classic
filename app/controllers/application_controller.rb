# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Authentication
  include SetCurrentRequestDetails
  per_request_react_rails_prerenderer
  before_action :sanitize_params!

  private
    def error_message_for(field, message, options = {})
      { errors: [OpenStruct.new(field: field, messages: [message])], **options }
    end

    def sanitize_params!
      strip_whitespace!(params)
    end

    def strip_whitespace!(params_to_strip)
      params_to_strip.each do |_, v|
        if v.respond_to? :strip!
          v.strip!
        elsif v.respond_to? :each_pair
          strip_whitespace!(v)
        end
      end
    end
end
