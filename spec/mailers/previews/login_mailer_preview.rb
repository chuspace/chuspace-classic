# frozen_string_literal: true

class LoginMailerPreview < ActionMailer::Preview
  def send_magic_login
    LoginMailer.with(person: Person.first).send_magic_login
  end
end
