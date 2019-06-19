# frozen_string_literal: true

class ImgproxyMiddleware < Rack::Proxy
  def perform_request(env)
    if env['PATH_INFO'].include?('/blobs/')
      url =
        Imgproxy.url_for(
          "local://#{env['PATH_INFO']}".freeze,
          width: 750, height: 350, resizing_type: :fill, sharpen: 0.5
        )

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
