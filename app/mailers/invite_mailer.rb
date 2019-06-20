# typed: true
# frozen_string_literal: true

class InviteMailer < ApplicationMailer
  def notify_invitee
    @invite = params[:invite]
    mail(to: @invite.email, subject: t('.subject'))
  end

  def send_rsvp
    @invite = params[:invite]
    mail(to: @invite.email, subject: t('.subject'))
  end
end
