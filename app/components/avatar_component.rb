# typed: ignore
# frozen_string_literal: true

class AvatarComponent < ApplicationComponent
  DEFAULT_CSS_CLASS = 'avatar lazy blur-up'

  attr_reader :avatar_url, :gravatar_url, :css_class, :type, :options
  validates :type, presence: true

  def initialize(avatar_url: nil, gravatar_url: nil, css_class: nil, type: :xs, options: {})
    @avatar_url = avatar_url
    @gravatar_url = gravatar_url
    @css_class = css_class
    @type = type
    @options = options
  end

  def size
    VARIANTS[type][:size]
  end

  def css_classes
    classes = [DEFAULT_CSS_CLASS]
    classes << "avatar--#{type}"
    classes << css_class if css_class
    classes.join(' ')
  end

  def call
    image_tag(avatar_url || gravatar_url, class: css_classes, alt: 'Avatar image', 'data-sizes': 'auto', **options)
  end
end
