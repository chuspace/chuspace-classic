# typed: false
# frozen_string_literal: true

class AvatarUploader < AppUploader
  Attacher.validate do
    validate_max_size 5.megabytes, message: 'is too large (max is 5 MB)'
    validate_mime_type_inclusion %w[image/jpeg image/jpg image/png image/gif]
  end
end
