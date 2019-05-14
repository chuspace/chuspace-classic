# frozen_string_literal: true

class InvitesController < ApplicationController
  def approve
    @invite = Invite.find_by_code(params[:invite_code])

    if @invite.accepted!
      redirect_to registrations_path(email: @invite.email, code: @invite.code), notice: t('.invite.create.success')
    else
      redirect_to root_path, notice:  @invite.errors.full_messages.to_sentence
    end
  end

  def create
    @invite = Invite.new(invite_params)

    if @invite.save
      redirect_to root_path, notice: t('.invite.create.success')
    else
      @status = 'invalid'
      @error = @invite.errors.full_messages.to_sentence

      render 'pages/index'
    end
  end

  private

  def invite_params
    params.require(:invite).permit(:email)
  end
end
