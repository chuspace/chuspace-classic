# frozen_string_literal: true

class Autocomplete::PostsController < ApplicationController
  def index
    @posts = Post.published.where("unaccent(posts.title) ILIKE unaccent('%#{params[:q]}%') OR unaccent(posts.summary) ILIKE unaccent('%#{params[:q]}%')")

    render json: @posts.to_json
  end
end
