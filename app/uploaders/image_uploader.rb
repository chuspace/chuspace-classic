# frozen_string_literal: true

# typed: false

class ImageUploader < AppUploader
  plugin :pretty_location
  plugin :default_url_options, store: { host: ENV.fetch('REPOSITORY_ENDPOINT') }

  Attacher.validate do
    validate_max_size 5.megabytes, message: 'is too large (max is 5 MB)'
    validate_mime_type_inclusion %w[image/jpeg image/jpg image/png image/gif]
  end

  def generate_location(io, context)
    name = super

    [Image::UPLOAD_PATH, name].compact.join('/')
  end
end
