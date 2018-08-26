# frozen_string_literal: true

module DialogHelper
  def dialog(options:, &block)
    options[:class] = "dialog #{options[:class]}".strip
    options['data-controller'] = 'dialog'
    content_tag(:dialog, options, &block)
  end
end
