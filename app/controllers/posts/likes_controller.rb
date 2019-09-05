# typed: strong
# frozen_string_literal: true

class Posts::LikesController < ApplicationController
  before_action :authenticate!
  before_action :find_publication, :find_post

  def create
    if @post.liked_by?(user: Current.user)
      unlike
    else
      like = @post.likes.build(user: Current.user)
      authorize! like
      like.save

      respond_to do |format|
        format.js
        format.html { redirect_to publication_post_path(@publication, @post) }
      end
    end
  end

  private

  def unlike
    like = @post.likes.find_by(user: Current.user)
    authorize! like
    like.destroy

    respond_to do |format|
      format.js
      format.html { redirect_to publication_post_path(@publication, @post) }
    end
  end

  def find_publication
    @publication = Publication.find_by(slug: params[:publication_slug])
  end

  def find_post
    @post = @publication.posts.find_by(slug: params[:post_slug])
  end
end
