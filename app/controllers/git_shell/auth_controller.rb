# frozen_string_literal: true

module GitShell
  class AuthController < ActionController::Metal
    include AbstractController::Rendering
    include ActionController::Renderers::All
    include ActionController::MimeResponds
    include Rails.application.routes.url_helpers

    def create
      ssh_key = SshKey.find_by(key: params[:key])

      if ssh_key
        render json: { command: @ssh_key.command_with_key, allowed: true }
      else
        render json: { allowed: false }
      end
    end
  end
end
