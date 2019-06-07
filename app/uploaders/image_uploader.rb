# frozen_string_literal: true

class ImageUploader < AppUploader
  Attacher.validate do
    validate_max_size 15.megabytes, message: 'is too large (max is 15 MB)'
    validate_mime_type_inclusion %w[image/jpeg image/jpg image/png image/gif]
  end

  process(:store) do |io|
    versions = { original: io }

    io.download do |original|
      pipeline = ImageProcessing::Vips.source(original)
      versions[:mega] = pipeline.resize_to_limit!(2500, nil)
      versions[:header] = pipeline.resize_to_limit!(1400, 700)
      versions[:post] = pipeline.resize_to_fill!(750, 350)
      versions[:grid] = pipeline.resize_to_fill!(350, 350)
      versions[:tooltip] = pipeline.resize_to_fill!(300, 200)
    end

    versions
  end
end
