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

  def invite
    @invitation = params[:invitation]
    @sender = @invitation.sender
    @publication = @invitation.publication

    @subject = t('.subject', sender: @sender.nickname, publication: @publication.slug)
    mail(to: @invitation.recipient_email, subject: @subject)
  end
end
