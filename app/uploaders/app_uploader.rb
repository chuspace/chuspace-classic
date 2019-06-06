# frozen_string_literal: true

class AppUploader < Shrine
  include ImageProcessing::Vips

  plugin :backgrounding
  plugin :determine_mime_type
  plugin :store_dimensions
  plugin :validation_helpers
  plugin :pretty_location
  plugin :processing
  plugin :versions
  plugin :delete_promoted
  plugin :delete_raw
  plugin :cached_attachment_data
  plugin :logging
  plugin :recache

  Attacher.promote { |data| ShrineBackgrounding::PromoteJob.perform_later(data) }
  Attacher.delete { |data| ShrineBackgrounding::DeleteJob.perform_later(data) }
end
