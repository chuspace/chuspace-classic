# typed: false
# frozen_string_literal: true

require 'mimemagic'

class ImgproxyMiddleware < Rack::Proxy
  attr_reader :root

  def initialize(app, opts: {})
    @root = opts[:path]

    super
  end

  def perform_request(env)
    req = Rack::Request.new env
    path = req.path_info.chomp('/'.freeze)
    match = match?(path)

    if (req.get? || req.head?) && match
      u = URI.parse(match)
      env['HTTP_HOST'] =
        env['HTTP_X_FORWARDED_HOST'] = env['HTTP_X_FORWARDED_SERVER'] = ENV.fetch('IMGPROXY_HOST_WITH_PORT')
      env['PATH_INFO'] = u.request_uri

      super(env)
    else
      @app.call(env)
    end
  end

  private

  def match?(path)
    path = ::Rack::Utils.unescape_path path
    return false unless ::Rack::Utils.valid_path? path

    path = ::Rack::Utils.clean_path_info path
    full_path = File.join(root, path.b)

    return false unless File.file?(full_path) && File.readable?(full_path) && MimeMagic.by_path(full_path).image?

    Imgproxy.url_for("local://#{path}", width: 750, height: 300, resizing_type: :fill, sharpen: 0.5)
  end
end
