# typed: ignore
# frozen_string_literal: true

require 'mimemagic'

class ImageConstraint
  def matches?(request)
    route = Rails.application.routes.recognize_path(request.referrer || '')
    route[:controller] == 'posts' && route[:action] == 'edit' && MimeMagic.by_path(request.path)&.image?
  rescue ActionController::RoutingError
    false
  end
end
