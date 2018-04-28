# frozen_string_literal: true

module RouteHelpers
  extend ActiveSupport::Concern

  class_methods do
    def url_for(args)
      Rails.application.routes.url_helpers.url_for(args)
    end
  end
end
