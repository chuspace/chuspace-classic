# typed: ignore
# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'hello@notifications.chuspace.com'
  layout 'mailer'
end
