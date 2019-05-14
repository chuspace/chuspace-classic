# frozen_string_literal: true

class InputComponent < Components::Component
  DEFAULT_CSS_CLASS = 'input'

  attribute :name
  attribute :form
  attribute :type, default: :text
  attribute :css_class
  attribute :help_text
  attribute :placeholder, default: 'Type something...'
  attribute :options, default: {}

  validates :name, :form, presence: true

  def css_classes
    classes = [DEFAULT_CSS_CLASS]
    classes << css_class
  end
end
