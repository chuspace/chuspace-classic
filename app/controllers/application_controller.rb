# typed: ignore
# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ParamsSanitizer
  include Authentication
  include SetCurrentRequestDetails

  delegate :t, to: :I18n

  private

  def errors_for(field, message)
    [{ field: field.to_sym, errors: message }]
  end
end
