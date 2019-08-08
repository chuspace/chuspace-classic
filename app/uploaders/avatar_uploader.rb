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
  plugin :restore_cached_data
  plugin :cached_attachment_data
  plugin :instrumentation
  plugin :recache
  plugin :default_url_options, store: { host: ENV.fetch('AVATAR_ENDPOINT') }

  Attacher.validate do
    validate_max_size 5.megabytes, message: 'is too large (max is 5 MB)'
    validate_mime_type_inclusion %w[image/jpeg image/jpg image/png image/gif]
  end
end
