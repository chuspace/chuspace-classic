# typed: ignore
# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ParamsSanitizer
  include Authentication
  include SetCurrentRequestDetails

  after_action :verify_authorized
  around_filter :identity_cache_memoization

  delegate :t, to: :I18n
  rescue_from ActionPolicy::Unauthorized, with: :user_not_authorized

  private

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore
    flash[:error] = t "#{policy_name}.#{exception.rule}", scope: 'policy', default: :default

    redirect_to root_path
  end

  def current_user
    Current.user
  end

  def identity_cache_memoization
    IdentityCache.cache.with_memoization { yield }
  end
end
