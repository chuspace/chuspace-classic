module Mobius
  class BaseController < ActionController::Metal
    include AbstractController::Rendering
    include Rails.application.routes.url_helpers
    include ActionController::MimeResponds
  end
end
