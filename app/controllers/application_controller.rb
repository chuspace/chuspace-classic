# typed: ignore
# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ParamsSanitizer
  include Authentication
  include SetCurrentRequestDetails
  include TurbolinksCacheControl

  after_action :verify_authorized
  before_action :set_raven_context
  helper_method :signed_in?

  delegate :t, to: :I18n
  rescue_from ActionPolicy::Unauthorized, with: :user_not_authorized

  private

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore
    flash[:error] = t "#{policy_name}.#{exception.rule}", scope: 'policy', default: :default

    raise ActionController::RoutingError.new('Not Found')
  end

  def set_raven_context
    Raven.user_context(id: current_user&.id)
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end

  def current_user
    Current.user
  end

  def signed_in?
    Current.user.present?
  end
end
