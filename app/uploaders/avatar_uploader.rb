# frozen_string_literal: true

# typed: false
class AppUploader < Shrine
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
  plugin :logging
  plugin :recache

  Attacher.validate do
    validate_max_size 5.megabytes, message: 'is too large (max is 5 MB)'
    validate_mime_type_inclusion %w[image/jpeg image/jpg image/png image/gif]
  end
end
