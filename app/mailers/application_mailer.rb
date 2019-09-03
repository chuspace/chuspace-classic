# typed: ignore
# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  add_template_helper(Components::ComponentHelper)

  default from: 'hello@notifications.chuspace.com'
  layout 'mailer'
end
