# typed: ignore
# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def welcome
    @user = params[:user]
    @subject = t('.subject', name: @user.name)
    mail(to: @user.email, subject: @subject)
  end

  def send_magic_login
    @user = params[:user]
    @subject = t('.subject', name: @user.name)
    mail(to: @user.email, subject: @subject)
  end
end
