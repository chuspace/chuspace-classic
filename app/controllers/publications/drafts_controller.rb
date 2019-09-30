# typed: ignore
# frozen_string_literal: true

class Publications::DraftsController < ApplicationController
  before_action :authenticate!, :find_publication

  def index
    authorize! @publication, to: :publish?

    @posts = @publication.posts.draft.includes(:author).limit(20).order(id: :desc)
    render 'publications/show'
  end

  private

  def find_publication
    @publication = Publication.friendly.find(params[:publication_slug])
  end
end
