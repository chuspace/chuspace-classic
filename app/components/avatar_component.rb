# typed: ignore
# frozen_string_literal: true

class AvatarComponent < Components::Component
  DEFAULT_CSS_CLASS = 'avatar lazy'

  attribute :avatar_url
  attribute :gravatar_url
  attribute :css_class
  attribute :variant, default: :xs
  attribute :options, default: {}

  def size
    VARIANTS[variant][:size]
  end

  def css_classes
    classes = [DEFAULT_CSS_CLASS]
    classes << "avatar--#{variant}"
    classes << css_class if css_class
    classes.join(' ')
  end

  def render
    avatar_tag(url: avatar_url || gravatar_url)
  end

  private

  def avatar_tag(url:)
    @view.image_tag(url, class: css_classes, 'data-sizes': 'auto', **options)
  end
end
