# typed: false
# frozen_string_literal: true

class Posts::LikesController < ApplicationController
  before_action :authenticate!
  include PublicationFinder, PostFinder

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
end
