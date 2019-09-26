# typed: ignore
# frozen_string_literal: true

class Publications::PeopleController < ApplicationController
  before_action :authenticate!, except: :index
  before_action :find_publication
  before_action :find_collaborator, only: %i[update destroy]
  skip_verify_authorized only: %i[index autocomplete]

  def index
    @collaborators = @publication.collaborators.order(:created_at)
    @invitation = @publication.invitations.build
  end

  def update
    @collaborator.update(update_params)
    authorize! @collaborator

    redirect_to publication_people_path(@publication), notice: t('publications.people.update.success')
  end

  def destroy
    @collaborator.destroy
    authorize! @collaborator

    redirect_to publication_people_path(@publication), notice: t('publications.people.destroy.success')
  end

  def autocomplete
    @query = params[:q]
    @users = User.search(query: @query)

    respond_to { |type| type.html_fragment { render partial: 'publications/people/autocomplete' } }
  end

  private

  def update_params
    params.permit(:role)
  end

  def find_publication
    @publication = Publication.friendly.find(params[:publication_slug])
  end

  def find_collaborator
    @collaborator = @publication.collaborators.find(params[:id])
  end
end
