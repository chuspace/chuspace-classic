# typed: ignore
# frozen_string_literal: true

class AvatarComponent < Components::Component
  DEFAULT_CSS_CLASS = 'avatar'

  VARIANTS = {
    sm: { size: 32, class: 'avatar--sm' },
    md: { size: 64, class: 'avatar--md' },
    lg: { size: 80, class: 'avatar--lg' },
    xl: { size: 120, class: 'avatar--xl' }
  }.freeze

  attribute :avatar
  attribute :variant, default: :sm
  attribute :initials
  attribute :options, default: {}

  validates :initials, presence: true

  def size
    VARIANTS[variant][:size]
  end

  def css_classes
    classes = [DEFAULT_CSS_CLASS]
    classes << 'avatar__badge' if avatar.blank?
    classes << VARIANTS[variant][:class]
    classes.join(' ')
  end

  def render
    avatar.blank? ? initials_badge : image
  end

  private

  def avatar_url
    Imgproxy.url_for("s3://#{avatar}", width: size, height: size, resizing_type: :fill, sharpen: 0.5)
  end

  def initials_badge
    @view.content_tag(:div, initials, class: css_classes, **options)
  end

  def image
    @view.image_tag(avatar_url, class: css_classes, **options)
  end
end
