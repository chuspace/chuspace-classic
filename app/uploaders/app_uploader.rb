# frozen_string_literal: true

class AppUploader < Shrine
  include ImageProcessing::Vips

  plugin :determine_mime_type
  plugin :validation_helpers
  plugin :delete_promoted
  plugin :delete_raw
  plugin :logging

  Attacher.promote { |data| ShrineBackgrounding::PromoteJob.perform_later(data) }
  Attacher.delete { |data| ShrineBackgrounding::DeleteJob.perform_later(data) }
end
