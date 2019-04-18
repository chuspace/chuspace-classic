# frozen_string_literal: true

module FlashHelper
  def flash_message_class(level)
    case level.to_sym
    when :notice
      'alert alert-info'
    when :success
      'alert alert-success'
    when :error
      'alert alert-error'
    when :alert
      'alert alert-error'
    end
  end
end
