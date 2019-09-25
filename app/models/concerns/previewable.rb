# frozen_string_literal: true

# typed: false

module Previewable
  PREVIEW_IMAGE_VARIANTS = { list: { width: 150, height: 150 }, thumb: { width: 320, height: 220 } }.freeze
  class PreviewImageVariantNotFound < StandardError; end

  extend ActiveSupport::Concern

  def preview_image_url(variant: :list)
    size = PREVIEW_IMAGE_VARIANTS[variant] || fail(PreviewImageVariantNotFound, 'Preview image variant not found')
    preview_image&.derivation_url(:variant, size[:width] * 2, size[:height] * 2)
  end
end
