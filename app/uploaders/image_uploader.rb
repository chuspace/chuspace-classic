# typed: false
# frozen_string_literal: true

class ImageUploader < AppUploader
  Attacher.validate do
    validate_max_size 15.megabytes, message: 'is too large (max is 15 MB)'
    validate_mime_type_inclusion %w[image/jpeg image/jpg image/png image/gif]
  end
end
