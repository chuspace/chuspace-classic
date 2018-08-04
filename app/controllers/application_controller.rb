# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ParamsSanitizer
  include Authentication
  include SetCurrentRequestDetails

  per_request_react_rails_prerenderer
end
