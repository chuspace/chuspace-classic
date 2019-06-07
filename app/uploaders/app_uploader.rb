# frozen_string_literal: true

class AppUploader < Shrine
  include ImageProcessing::Vips

  plugin :pretty_location
  plugin :processing
  plugin :add_metadata
  plugin :determine_mime_type
  plugin :validation_helpers
  plugin :versions
  plugin :delete_promoted
  plugin :delete_raw
  plugin :restore_cached_data
  plugin :cached_attachment_data
  plugin :logging
  plugin :recache

  Attacher.promote { |data| ShrineBackgrounding::PromoteJob.perform_later(data) }
  Attacher.delete { |data| ShrineBackgrounding::DeleteJob.perform_later(data) }
end
