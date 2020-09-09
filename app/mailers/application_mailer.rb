# typed: ignore
# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  add_template_helper(ElementalComponents::ComponentHelper)

  default from: 'Chuspace <hello@notifications.chuspace.com>'
  layout 'mailer'
end
