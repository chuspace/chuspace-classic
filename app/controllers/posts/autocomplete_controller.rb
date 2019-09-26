# typed: ignore
# frozen_string_literal: true

class Posts::AutocompleteController < ApplicationController
  before_action :authenticate!, :find_publication, :find_post

  def index
    authorize! ::Posts::Publish, context: { post: @post }

    @posts = @publication.posts.where.not(id: @post.id).autocomplete_search(query: params[:q]).limit(10)
    respond_to { |type| type.html_fragment { render partial: 'posts/autocomplete' } }
  end

  private

  def find_publication
    @publication = Publication.friendly.find(params[:publication_slug])
  end

  def find_post
    @post = @publication.posts.friendly.find(params[:post_slug])
  end
end
