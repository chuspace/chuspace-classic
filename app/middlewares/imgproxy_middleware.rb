# typed: false
# frozen_string_literal: true

class ImgproxyMiddleware < Rack::Proxy
  def perform_request(env)
    if env['PATH_INFO'].include?('/images/')
      request = ActionDispatch::Request.new(env)

      authenticated_user = User.find_by(id: request.cookie_jar.encrypted[:user_id])
      image = authenticated_user.repository.images.find_by(blob_path: env['PATH_INFO'][1..-1])

      url = image.image.imgproxy_url(width: 750, height: 350, resizing_type: :fill, sharpen: 0.5)
      u = URI.parse(url)

      if u&.host && u.request_uri
        env['HTTP_HOST'] =
          env['HTTP_X_FORWARDED_HOST'] = env['HTTP_X_FORWARDED_SERVER'] = ENV.fetch('IMGPROXY_HOST_WITH_PORT')
        env['PATH_INFO'] = u.request_uri
      end

      super(env)
    else
      @app.call(env)
    end
  end
end
