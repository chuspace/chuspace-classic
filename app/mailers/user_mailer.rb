# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def magic_login
    mail(to: Current.user.email, subject: t('.subject'))
  end
end
