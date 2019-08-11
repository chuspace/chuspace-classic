# frozen_string_literal: true

# typed: false

class AppUploader < Shrine
  include ImageProcessing::Vips

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
end
