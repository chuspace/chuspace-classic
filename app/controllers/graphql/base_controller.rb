# frozen_string_literal: true

class Graphql::BaseController < ActionController::API
  include AbstractController::Translation
  include ActionController::Cookies
  include Pundit

  before_action :sanitize_params!

  rescue_from Pundit::NotAuthorizedError, with: :unauthorized_resource

  private
    def authenticate!
      authenticated_user = User.find_by(id: cookies.encrypted[:user_id])
      unauthorized_resource if authenticated_user.blank?
      Current.user = authenticated_user
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

    def unauthorized_resource
      render status: 403, json: { errors: [{ message: t('graphql.errors.unauthorized') }] }
    end

    def unauthorized_entity(_entity_name)
      not_found
    end

    def not_found
      render json: { errors: [{ message: t('graphql.errors.not_found') }] }, status: 401
    end
end
