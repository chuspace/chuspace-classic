# frozen_string_literal: true

class InputComponent < Components::Component
  attribute :name
  attribute :form
  attribute :type, default: nil
  attribute :css_class
  attribute :help_text
  attribute :placeholder, default: 'Type something...'
  attribute :options, default: {}

  validates :name, :form, presence: true

  def render
    form.input name, as: type, placeholder: placeholder, **options
  end
end
