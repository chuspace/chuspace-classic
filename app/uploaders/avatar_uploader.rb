# frozen_string_literal: true

# typed: false

class AvatarUploader < AppUploader
  plugin :derivation_endpoint,
         secret_key: ENV.fetch('DERIVATION_ENDPOINT_SECRET'),
         prefix: 'avatar/variants',
         host: ENV.fetch('AVATAR_ENDPOINT'),
         upload_options: { acl: 'public-read' },
         upload_open_options: { response_content_encoding: 'gzip' },
         upload: true

  Attacher.validate do
    validate_max_size 5.megabytes, message: 'is too large (max is 5 MB)'
    validate_mime_type_inclusion %w[image/jpeg image/jpg image/png image/gif]
  end

  derivation :thumbnail do |file, width, height|
    ImageProcessing::Vips.source(file).resize_to_limit!(width.to_i, height.to_i)
  end
end
