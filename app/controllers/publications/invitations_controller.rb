# typed: ignore
# frozen_string_literal: true

class Publications::InvitationsController < ApplicationController
  before_action :authenticate!, except: :accept
  before_action :authenticate, only: :accept
  before_action :find_publication
  skip_verify_authorized only: :accept, if: -> { Current.user.blank? }

  def create
    @collaborators = @publication.collaborators.order(:created_at)
    @invitation = @publication.invitations.build(invitation_params)
    @invitation.sender = Current.user

    authorize! @invitation

    respond_to do |format|
      if @invitation.save
        format.html do
          redirect_to(
            publication_people_path(@publication),
            notice: t('invitations.create.success', identifier: @invitation.identifier, publication: @publication.name)
          )
        end
      else
        format.js
        format.html do
          redirect_to publication_people_path(@publication), notice: @invitation.errors.full_messages.to_sentence
        end
      end
    end
  end

  def accept
    @invitation = @publication.invitations.find_by_code(params[:invite_token])

    if @invitation
      if Current.user.blank?
        if @invitation.recipient.blank?
          redirect_to(
            signups_path(return_to: accept_publication_invitations_path(@publication, invite_token: @invitation.code))
          )
        else
          redirect_to(
            signins_path(return_to: accept_publication_invitations_path(@publication, invite_token: @invitation.code))
          )
        end
      else
        @invitation = @publication.invitations.find_by_code(params[:invite_token])
        authorize! @invitation

        @publication.collaborators.create(role: @invitation.role, user: @invitation.recipient)
        @invitation.destroy

        redirect_to(
          publication_people_path(@publication),
          notice: t('invitations.accept.success', publication: @publication.name, role: @invitation.role)
        )
      end
    else
      redirect_to publication_path(@publication, error: 'Invitation not found')
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:identifier, :role)
  end

  def find_publication
    @publication = Publication.friendly.find(params[:publication_slug])
  end
end
