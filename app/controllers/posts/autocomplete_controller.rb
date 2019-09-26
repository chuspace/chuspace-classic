# typed: ignore
# frozen_string_literal: true

class Posts::AutocompleteController < ApplicationController
  before_action :authenticate!
  include PublicationFinder, PostFinder

  def index
    authorize! ::Posts::Publish, context: { post: @post }

    @posts = @publication.posts.where.not(id: @post.id).autocomplete_search(query: params[:q]).limit(10)
    respond_to { |type| type.html_fragment { render partial: 'posts/autocomplete' } }
  end
end
