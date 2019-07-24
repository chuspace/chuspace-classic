# typed: ignore
# frozen_string_literal: true

class AppUploader < Shrine
  plugin :pretty_location
  plugin :activerecord
  plugin :add_metadata
  plugin :determine_mime_type
  plugin :store_dimensions
  plugin :validation_helpers
  plugin :delete_promoted
  plugin :dynamic_storage
  plugin :delete_raw
  plugin :restore_cached_data
  plugin :cached_attachment_data
  plugin :logging
  plugin :recache
  plugin :default_storage, store: ->(record, name) {
    case record.class.name
    when 'Post'
      "store_#{record.author.nickname}"
    when 'Image'
      "store_#{record.user.nickname}"
    when 'User'
      "store_#{record.nickname}"
    else
      'store_chuspaceassets'
    end
  }

  storage /store_(\w+)/ do |match|
    bucket_name = match[1]
    Shrine::Storage::S3.new(upload_options: { acl: 'public-read' }, bucket: bucket_name, **s3_options)
  end

  def self.s3_options
    {
      access_key_id: ENV.fetch('AWS_ACCESS_KEY_ID'),
      secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY'),
      endpoint: ENV.fetch('S3_ENDPOINT'),
      region: ENV.fetch('AWS_REGION')
    }
  end
end
