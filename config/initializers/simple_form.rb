# frozen_string_literal: true

SimpleForm.setup do |config|
  config.wrappers :custom, tag: 'div', class: 'input__container', error_class: 'input__container--invalid', valid_class: 'input__container' do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :minlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label, class: 'input__label'
    b.use :input, class: 'input', autocomplete: 'off', spellcheck: 'off'
    b.use :hint,  wrap_with: { tag: :span, class: 'input__hint' }
    b.use :full_error, wrap_with: { tag: 'div', class: 'input__error' }
  end

  config.default_form_class = 'form'
  config.label_text = lambda { |label, required, explicit_label| "#{label} #{required}" }

  config.default_wrapper = :custom

  config.boolean_style = :nested
  config.button_class = 'button button--active'
  config.error_notification_tag = :div
  config.error_notification_class = 'alert alert__error'
  config.browser_validations = false
  config.boolean_label_class = 'checkbox'
  config.i18n_scope = 'form'
end
