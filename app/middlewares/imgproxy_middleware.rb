# typed: false
# frozen_string_literal: true

class ImgproxyMiddleware < Rack::Proxy
  def perform_request(env)
    if env['PATH_INFO'].end_with?('.png', '.jpeg', '.jpg', '.gif')
      request = ActionDispatch::Request.new(env)
      authenticated_user = User.find_by(id: request.cookie_jar.encrypted[:user_id])
      file_server = ActionDispatch::FileHandler.new(authenticated_user.repository.path)
      file_server.serve(request)

      super(env)
    else
      @app.call(env)
    end
  end
end
