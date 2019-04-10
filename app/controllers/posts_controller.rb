# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate!, only: [:new, :create]
  layout 'editor', only: :new

  def create
    post = Post.new(post_params)
    post.author = Current.person

    if post.valid?
      post.commit_to_blog(commit_message: params[:commit_message])
      redirect_to post_path(post)
    else
      render json: { errors: post.api_validation_errors }
    end
  end


  private

  def post_params
    params.require(:post).permit(:title, :excerpt, :content, :tags, :published_at)
  end
end
