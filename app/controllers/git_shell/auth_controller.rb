# frozen_string_literal: true

module GitShell
  class AuthController < ActionController::Metal
    include AbstractController::Rendering
    include ActionController::Renderers::All
    include ActionController::MimeResponds
    include Rails.application.routes.url_helpers

    def create
      fingerprint = OpenSSL::Digest::MD5.hexdigest(Base64.decode64(params[:key])).scan(/../).join(':')
      ssh_key = SshKey.find_by(fingerprint: fingerprint)

      if ssh_key
        render json: { command: ssh_key.command_with_key, allowed: true }
      else
        render json: { allowed: false }
      end
    end
  end
end
