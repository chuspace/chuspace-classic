# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'hello@chuspace.com'
  layout 'mailer'
end
