# frozen_string_literal: true

class ApplicationController < ActionController::Base
  per_request_react_rails_prerenderer
end
