# frozen_string_literal: true

class UserMailerPreview < ActionMailer::Preview
  def send_magic_login
    UserMailer.with(user: User.chuspace).send_magic_login
  end
end
