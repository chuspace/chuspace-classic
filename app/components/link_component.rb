# typed: true
# frozen_string_literal: true

class LinkComponent < Components::Component
  TYPES = %i[link button].freeze
  STATES = %i[default active danger disabled].freeze

  attribute :label
  attribute :url
  attribute :options, default: {}
  attribute :type, default: :link
  attribute :state, default: :default
  attribute :title
  attribute :css_class

  validates :label, presence: true
  validates :url, presence: true, url: true
  validates :type, inclusion: { in: TYPES }
  validates :state, inclusion: { in: STATES }

  def render
    @view.link_to(label.html_safe, url, class: css_classes, title: title || label, **options)
  end

  def css_classes
    classnames = [type]
    classnames << "#{type}--#{state}"
    classnames << css_class
    classnames.join(' ')
  end
end
