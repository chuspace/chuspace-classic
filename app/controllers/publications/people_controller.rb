# typed: ignore
# frozen_string_literal: true

class Publications::PeopleController < ApplicationController
  before_action :authenticate!
  before_action :find_publication
  skip_verify_authorized

  def index
    @members = @publication.members
    @invitation = @publication.invitations.build
  end

  def autocomplete
    @query = params[:q]
    @users = User.search(query: @query)

    respond_to do |type|
      type.html_fragment { render partial: 'publications/people/autocomplete' }
    end
  end

  private

  def find_publication
    @publication = Publication.find_by!(slug: params[:publication_slug])
  end
end
