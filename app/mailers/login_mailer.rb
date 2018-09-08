# frozen_string_literal: true

class LoginMailer < ApplicationMailer
  def send_magic_login
    @person = params[:person]
    mail(to: @person.email, subject: t('.subject'))
  end
end
