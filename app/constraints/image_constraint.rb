# typed: ignore
# frozen_string_literal: true

require 'mimemagic'

class ImageConstraint
  def matches?(request)
    MimeMagic.by_path(request.path)&.image?
  end
end
