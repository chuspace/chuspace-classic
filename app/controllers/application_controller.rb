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

  def redirect_to_back_or_default(default = root_url)
    if request.env['HTTP_REFERER'].present? && (request.env['HTTP_REFERER'] != request.env['REQUEST_URI'])
      redirect_to :back
    else
      redirect_to default
    end
  end
end
