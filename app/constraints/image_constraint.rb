# typed: ignore
# frozen_string_literal: true

require 'mimemagic'

class ImageConstraint
  def matches?(request)
    true
  end
end
