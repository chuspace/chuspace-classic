# typed: true
# frozen_string_literal: true

class AutocompleteInput < SimpleForm::Inputs::Base
  def input(wrapper_options = nil)
    out = ActiveSupport::SafeBuffer.new
    out << @builder.text_field(attribute_name, input_html_options)
    out <<
      template.content_tag(
        :ul,
        nil,
        id: input_html_options[:popup_id],
        role: 'listbox',
        class: 'dropdown dropdown__autocomplete dropdown__autocomplete--no-arrow'
      )
  end
end
