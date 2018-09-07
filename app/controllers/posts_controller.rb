# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate!, only: [:new, :create]
  layout 'editor', only: :new

  def index
    @posts = Post.all.order(id: :desc)
  end

  def new
  end

  def create
    post = Current.user.posts.build(post_params)

    if post.save
      redirect_to post_path(post)
    else
      render json: { errors: post.api_validation_errors }
    end
  end

  def show
    @post = Post.find_by(slug: params[:id])
    render component: 'posts/show', props: { body: @post.body }, prerender: true
  end

  private
  def post_params
    params.permit(:title, :body, :commit)
  end
end
