# frozen_string_literal: true

# typed: strict

class AppUploader < Shrine
  include ImageProcessing::Vips

  plugin :pretty_location
  plugin :add_metadata
  plugin :determine_mime_type
  plugin :store_dimensions
  plugin :validation_helpers

  unless Rails.env.test?
    plugin :restore_cached_data
    plugin :cached_attachment_data
    plugin :instrumentation
  end
end
