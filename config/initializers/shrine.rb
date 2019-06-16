# frozen_string_literal: true

require 'shrine'
require 'shrine/plugins/activerecord'
require 'shrine/plugins/backgrounding'
require 'shrine/plugins/delete_promoted'
require 'shrine/plugins/delete_raw'
require 'shrine/storage/s3'
require 'shrine/storage/file_system'
require 'shrine/plugins/logging'
require 'shrine/plugins/determine_mime_type'
require 'shrine/plugins/store_dimensions'
require 'shrine/plugins/cached_attachment_data'
require 'shrine/plugins/restore_cached_data'
require 'shrine/plugins/validation_helpers'
require 'shrine/plugins/pretty_location'

Shrine.plugin :activerecord
Shrine.plugin :backgrounding
Shrine.plugin :determine_mime_type

def production_storages
  s3_options = {
    access_key_id: Rails.application.credentials.digitalocean_spaces_key,
    secret_access_key: Rails.application.credentials.digitalocean_spaces_secret,
    bucket: Rails.application.credentials.digitalocean_spaces_bucket,
    endpoint: 'https://nyc3.digitaloceanspaces.com',
    region: 'nyc3'
  }

   {
    cache: Shrine::Storage::FileSystem.new('public/uploads', prefix: 'cache'), # temporary
    store: Shrine::Storage::S3.new(prefix: 'store', upload_options: { acl: 'public-read' }, **s3_options)
  }
end

def development_storages
  {
    cache: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/cache'),
    store: Shrine::Storage::FileSystem.new('public', prefix: 'uploads'),
  }
end

 Shrine.storages = Rails.env.production? ? production_storages : development_storages
