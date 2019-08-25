# typed: ignore
# frozen_string_literal: true

SimpleForm.setup do |config|
  config.wrappers :custom,
                  tag: 'div',
                  class: 'form_field__container',
                  error_class: 'form_field__container--invalid',
                  valid_class: 'form_field__container' do |b|

    b.use :label, class: 'input__label'

    b.wrapper :input_container, tag: 'div', class: 'input__container' do |input|
      input.use :html5
      input.optional :placeholder
      input.optional :maxlength
      input.optional :minlength
      input.optional :pattern
      input.optional :min_max
      input.optional :readonly
      input.use :input, class: 'input', autocomplete: 'off', spellcheck: 'off'
    end

    b.use :hint, wrap_with: { tag: :span, class: 'input__hint' }
    b.use :error, wrap_with: { tag: 'div', class: 'input__error' }
  end

  config.default_form_class = 'form'
  config.label_text = ->(label, required, explicit_label) { "#{label} #{required}" }

  config.default_wrapper = :custom

  config.boolean_style = :nested
  config.button_class = 'button button--fill'
  config.error_notification_tag = :div
  config.error_notification_class = 'alert alert__error'
  config.browser_validations = false
  config.boolean_label_class = 'checkbox'
  config.i18n_scope = 'form'
end
