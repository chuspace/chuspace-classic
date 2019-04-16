# frozen_string_literal: true

class LoginMailerPreview < ActionMailer::Preview
  def send_magic_login
    LoginMailer.with(user: User.first).send_magic_login
  end
end
