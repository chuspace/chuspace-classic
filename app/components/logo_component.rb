# typed: ignore
# frozen_string_literal: true

class LogoComponent < Components::Component
  TYPES = {
    badge: { css_class: 'logo--badge', label: 'C' }, text: { css_class: 'logo--text', label: 'Chuspace', version: 'axiom' }
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
    TYPES[type.to_sym][:version]
  end
end
