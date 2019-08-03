# typed: strict
# frozen_string_literal: true

require 'aws-sdk-s3'

Aws.config.update(
  endpoint: Rails.env.development? ? ENV.fetch('S3_ENDPOINT') : nil,
  access_key_id: ENV.fetch('AWS_ACCESS_KEY_ID'),
  secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY'),
  force_path_style: Rails.env.development?,
  region: ENV.fetch('AWS_REGION')
)
