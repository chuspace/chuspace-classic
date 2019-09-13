# frozen_string_literal: true

# typed: false

class AvatarUploader < Shrine
  include ImageProcessing::Vips

  plugin :pretty_location
  plugin :add_metadata
  plugin :determine_mime_type
  plugin :store_dimensions
  plugin :validation_helpers
  plugin :delete_promoted
  plugin :delete_raw
  plugin :derivation_endpoint,
         secret_key: ENV.fetch('DERIVATION_ENDPOINT_SECRET'),
         prefix: 'avatar/variants',
         host: ENV.fetch('AVATAR_ENDPOINT'),
         upload_options: { acl: 'public-read' },
         upload_open_options: { response_content_encoding: 'gzip' },
         upload: true,
         upload_redirect: true,
         expires_in: 90

  unless Rails.env.test?
    plugin :restore_cached_data
    plugin :cached_attachment_data
    plugin :instrumentation
    plugin :recache
  end

  Attacher.validate do
    validate_max_size 5.megabytes, message: 'is too large (max is 5 MB)'
    validate_mime_type_inclusion %w[image/jpeg image/jpg image/png image/gif]
  end

  derivation :thumbnail do |file, width, height|
    ImageProcessing::Vips.source(file).resize_to_limit!(width.to_i, height.to_i)
  end
end
