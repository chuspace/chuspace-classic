# typed: ignore
# frozen_string_literal: true

require 'shrine'
require 'shrine/plugins/activerecord'
require 'shrine/plugins/delete_promoted'
require 'shrine/plugins/delete_raw'
require 'shrine/storage/s3'
require 'shrine/plugins/default_storage'
require 'shrine/plugins/dynamic_storage'
require 'shrine/storage/file_system'
require 'shrine/plugins/logging'
require 'shrine/plugins/determine_mime_type'
require 'shrine/plugins/store_dimensions'
require 'shrine/plugins/cached_attachment_data'
require 'shrine/plugins/restore_cached_data'
require 'shrine/plugins/validation_helpers'
require 'shrine/plugins/pretty_location'

Shrine.plugin :determine_mime_type

s3_options = {
  access_key_id: ENV.fetch('AWS_ACCESS_KEY_ID'),
  secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY'),
  bucket: ENV.fetch('AWS_DEFAULT_BUCKET'),
  endpoint: ENV.fetch('S3_ENDPOINT'),
  region: ENV.fetch('AWS_REGION')
}

Shrine.storages = {
  cache: Shrine::Storage::FileSystem.new('public/uploads', prefix: 'cache'),
  store: Shrine::Storage::S3.new(upload_options: { acl: 'public-read' }, **s3_options)
}
