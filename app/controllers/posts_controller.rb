# typed: ignore
# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate!, only: %i[create update destroy]
  before_action :find_post, only: %i[show update destroy]

  def index
    @posts = Post.all.limit(20).order(id: :desc)
  end

  def show
    redirect_to root_path if @post.blank?
  end

  def create
    post = Current.user.posts.build(post_params)

    if post.save
      redirect_to post_path(post)
    else
      redirect_to :back
    end
  end

  def update
    @post.assign_attributes(post_params)

    if @post.save
      render json: { saved: true }
    else
      render json: { errors: @post.errors.full_messages }
    end
  end

  def destroy
    if @post.destroy
      redirect_to root_path
    else
      redirect_to post_path(@post)
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :summary, :body, :topics, :published_at, :parent)
  end

  def find_post
    @post = Current.user.posts.find_by(slug: params[:slug])
  end
end
