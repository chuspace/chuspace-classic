# frozen_string_literal: true

class BlobUploader < AppUploader
  Attacher.validate do
    validate_max_size 15.megabytes, message: 'is too large (max is 15 MB)'

    unless record.blob.metadata['mime_type'].start_with?('image', 'text')
      message = 'must be Markdown(.md), JPEG, PNG or GIF'
      whitelist = %w[image/jpeg image/jpg image/png image/gif text/x-c text/plain text/plain text/x-java]
      add_error(:mime_type_inclusion, message, whitelist) && false
    end
  end

  process(:store) do |io|
    versions = {}

    if io.mime_type.include?('image')
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
end
