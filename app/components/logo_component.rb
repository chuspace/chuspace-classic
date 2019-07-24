# typed: ignore
# frozen_string_literal: true

class LogoComponent < Components::Component
  TYPES = {
    badge: { css_class: 'logo logo__badge', label: 'chu' }, full: { css_class: 'logo', label: "<span class='logo__badge'>chu</span>space", version: 'axiom' }
  }.freeze

  attribute :type
  validates :type, presence: true, inclusion: { in: TYPES.keys }

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
