# frozen_string_literal: true

# typed: false

class PreviewImageUploader < AppUploader
  plugin :remote_url, max_size: 15.megabytes
  plugin :infer_extension
  plugin :derivation_endpoint,
         secret_key: ENV.fetch('DERIVATION_ENDPOINT_SECRET'),
         prefix: 'images/variants',
         host: ENV.fetch('IMAGES_ENDPOINT'),
         upload_options: { acl: 'public-read' },
         upload_open_options: { response_content_encoding: 'gzip' },
         upload: true

  Attacher.validate do
    validate_max_size 15.megabytes, message: 'is too large (max is 5 MB)'
    validate_mime_type_inclusion %w[image/jpeg image/jpg image/png image/gif]
  end

  derivation :variant do |file, width, height|
    ImageProcessing::Vips.source(file).resize_to_fit(width.to_i, height.to_i).convert('png').saver(quality: 100).call
  end
end
