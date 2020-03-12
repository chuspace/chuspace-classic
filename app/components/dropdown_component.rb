# typed: ignore
# frozen_string_literal: true

class DropdownComponent < ElementalComponents::Component
  DEFAULT_CSS_CLASS = 'dropdown'
  element :opener
  element :body
  attribute :items
  attribute :drop_arrow, default: :yes
  attribute :css_class

  def arrow?
    drop_arrow == :yes
  end

  def css_classes
    classes = [DEFAULT_CSS_CLASS]
    classes << css_class if css_class
    classes.join(' ')
  end
end
