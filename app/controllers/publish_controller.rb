# typed: ignore
# frozen_string_literal: true

class PublishController < ApplicationController
  before_action :authenticate!, only: :create
  before_action :find_post, only: %i[show update destroy]

  def create
    if @post.update(publish_params)
      redirect_to post_path(@post)
    else
      redirect_to edit_post_path(@post)
    end
  end

  private

  def publish_params
    params.require(:post).permit(:title, :summary, :body, :topics, :published_at, :parent)
  end

  def find_post
    @post = Current.user.posts.find_by(slug: params[:post_slug])
  end
end
