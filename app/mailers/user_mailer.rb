# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def send_magic_login
    @user = params[:user]
    mail(to: @user.email, subject: t('.subject'))
  end
end
