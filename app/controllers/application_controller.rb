# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Authentication
  include SetCurrentRequestDetails
  before_action :onboard!

  per_request_react_rails_prerenderer

  def onboard!
    redirect_to onboarding_path if Current.user && Current.user.pending?
  end
end
