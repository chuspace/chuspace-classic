# typed: ignore
# frozen_string_literal: true

class AvatarComponent < Components::Component
  DEFAULT_CSS_CLASS = 'avatar'

  VARIANTS = {
    sm: { size: 32, class: 'avatar--sm' },
    md: { size: 64, class: 'avatar--md' },
    lg: { size: 80, class: 'avatar--lg' },
    xl: { size: 120, class: 'avatar--xl' },
    thumb: { size: 150, class: 'avatar--thumb' }
  }.freeze

  attribute :avatar
  attribute :gravatar
  attribute :css_class
  attribute :variant, default: :sm
  attribute :options, default: {}

  def size
    VARIANTS[variant][:size]
  end

  def css_classes
    classes = [DEFAULT_CSS_CLASS]
    classes << VARIANTS[variant][:class]
    classes << css_class if css_class
    classes.join(' ')
  end

  def render
    avatar_tag(avatar.present? ? avatar_url : gravatar_url)
  end

  private

  def avatar_url
    avatar.imgproxy_url(width: size * 2, height: size * 2, quality: 100, format: :png)
  end

  def gravatar_url
    gravatar + "&s=#{size * 2}"
  end

  def avatar_tag(url)
    @view.image_tag(url, class: css_classes, **options)
  end
end
