# typed: ignore
# frozen_string_literal: true

class Publications::DraftsController < ApplicationController
  before_action :authenticate!
  skip_verify_authorized
  include PublicationFinder

  def index
    @posts = @publication.posts.draft.includes(:author).limit(20).order(id: :desc)
    render 'publications/show'
  end
end
