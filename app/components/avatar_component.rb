# frozen_string_literal: true

class AvatarComponent < Components::Component
  DEFAULT_CSS_CLASS = 'avatar'

  VARIANTS = {
    xs: { size: 40, class: 'avatar--xs' },
    sm: { size: 80, class: 'avatar--sm' },
    md: { size: 120, class: 'avatar--md' },
    lg: { size: 150, class: 'avatar--lg' }
  }.freeze

  attribute :avatar
  attribute :variant, default: :xs
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

  def initials_badge
    @view.content_tag(:div, initials, class: css_classes, **options)
  end

  def image
    url = Rails.application.routes.url_helpers.url_for(avatar.variant(resize_to_fit: [size, size]))
    @view.image_tag(url, class: css_classes, **options)
  end
end
