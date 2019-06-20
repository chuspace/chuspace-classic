# typed: true
# frozen_string_literal: true

class LogoComponent < Components::Component
  TYPES = {
    badge: { css_class: 'logo--badge', label: 'C' }, text: { css_class: 'logo--text', label: 'Chuspace' }
  }.freeze

  attribute :type
  validates :type, presence: true, inclusion: { in: TYPES.keys }

  def css_class
    TYPES[type.to_sym][:css_class]
  end

  def label
    TYPES[type.to_sym][:label]
  end

  def version
    'axiom'
  end
end
