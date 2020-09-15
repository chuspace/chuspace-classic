# typed: ignore
# frozen_string_literal: true

class LogoComponent < ApplicationComponent
  TYPES = {
    badge: { css_class: 'logo logo__badge', label: 'chuspace' },
    full: { css_class: 'logo logo__full', label: 'chuspace', version: 'axiom' }
  }.freeze

  validates :type, presence: true, inclusion: { in: TYPES.keys }

  def initialize(type: :badge)
    @type = type
    @css_class = css_class
    @label = label
    @version = version
  end

  attr_reader :type

  private

  def css_class
    classes = []
    classes << TYPES[type.to_sym][:css_class]
    classes << 'leading-normal logo__badge--black' if type == :badge
    classes.join(' ')
  end

  def label
    TYPES[type.to_sym][:label]
  end

  def version
    TYPES[type.to_sym][:version]
  end
end
