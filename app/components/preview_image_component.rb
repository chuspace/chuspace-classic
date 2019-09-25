# typed: ignore
# frozen_string_literal: true

class PreviewImageComponent < Components::Component
  DEFAULT_CSS_CLASS = 'preview__image lazy'

  attribute :url
  attribute :css_class
  attribute :variant, default: :thumb
  attribute :options, default: {}

  def size
    VARIANTS[variant][:size]
  end

  def css_classes
    classes = [DEFAULT_CSS_CLASS]
    classes << "preview__image--#{variant}"
    classes << css_class if css_class
    classes.join(' ')
  end

  def render
    @view.image_tag(url || '', class: css_classes, 'data-sizes': 'auto', **options)
  end
end
