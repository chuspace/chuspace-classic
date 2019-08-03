# typed: strict
# frozen_string_literal: true

require 'aws-sdk-s3'

options = {
  access_key_id: ENV.fetch('AWS_ACCESS_KEY_ID'),
  secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY'),
  region: ENV.fetch('AWS_REGION')
}

if Rails.env.development?
  options[:force_path_style] = true
  options[:endpoint] = ENV.fetch('S3_ENDPOINT')
end

Aws.config.update(**options)
