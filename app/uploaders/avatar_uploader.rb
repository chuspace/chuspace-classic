# frozen_string_literal: true

class AvatarUploader < AppUploader
  Attacher.validate do
    validate_max_size 5.megabytes, message: 'is too large (max is 5 MB)'
    validate_mime_type_inclusion %w[image/jpeg image/jpg image/png image/gif]
  end

  process(:store) do |io|
    versions = { original: io }

    io.download do |original|
      pipeline = ImageProcessing::Vips.source(original)
      versions[:xl] = pipeline.resize_to_limit!(120, 120)
      versions[:lg] = pipeline.resize_to_limit!(80, 80)
      versions[:md] = pipeline.resize_to_fill!(64, 64)
      versions[:sm] = pipeline.resize_to_fill!(32, 32)
    end

    versions
  end
end
