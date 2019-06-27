# typed: strict
# frozen_string_literal: true

require 'aws-sdk-s3'

Aws.config.update(
  endpoint: ENV.fetch('MINIO_ENDPOINT', 'http://127.0.0.1:9000'),
  access_key_id: ENV.fetch('MINIO_KEY'),
  secret_access_key: ENV.fetch('MINIO_SECRET'),
  force_path_style: true,
  region: 'us-east-1'
)
