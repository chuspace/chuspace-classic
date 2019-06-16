# frozen_string_literal: true

Imgproxy.configure do |config|
  # Full URL to where your imgproxy lives.
  config.endpoint = ENV.fetch('IMGPROXY_ENDPOINT')
  # Hex-encoded signature key
  config.hex_key = ENV.fetch('IMGPROXY_KEY')
  # Hex-encoded signature salt
  config.hex_salt = ENV.fetch('IMGPROXY_SALT')
end

Imgproxy.extend_shrine!(use_s3: !Rails.env.development?, host: ENV.fetch('CHUSPACE_URL'))
