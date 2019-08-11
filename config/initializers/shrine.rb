# typed: false
# frozen_string_literal: true

require 'shrine'
require 'shrine/plugins/activerecord'
require 'shrine/plugins/delete_promoted'
require 'shrine/plugins/delete_raw'
require 'shrine/storage/s3'
require 'shrine/storage/file_system'
require 'shrine/plugins/instrumentation'
require 'shrine/plugins/default_url_options'
require 'shrine/plugins/determine_mime_type'
require 'shrine/plugins/store_dimensions'
require 'shrine/plugins/cached_attachment_data'
require 'shrine/plugins/restore_cached_data'
require 'shrine/plugins/validation_helpers'
require 'shrine/plugins/pretty_location'

Shrine.plugin :activerecord
Shrine.plugin :determine_mime_type

 def production_storages
   s3_options = {
     access_key_id: ENV.fetch('AWS_ACCESS_KEY_ID'),
     secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY'),
     region: ENV.fetch('AWS_REGION'),
     bucket: ENV.fetch('AWS_S3_BUCKET')
   }

  {
    cache: Shrine::Storage::FileSystem.new('public', prefix: 'uploads'),
    store: Shrine::Storage::S3.new(prefix: 'uploads', upload_options: { acl: 'public-read' }, **s3_options)
  }
end

 def development_storages
   {
     cache: Shrine::Storage::FileSystem.new('public', prefix: 'uploads'),
     store: Shrine::Storage::FileSystem.new('public', prefix: 'uploads'),
   }
end

Shrine.storages = Rails.env.production? ? production_storages : development_storages
