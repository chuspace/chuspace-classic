# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate!, only: [:new, :create]
  layout 'editor', only: :new

  def index
    @posts = Post.all.order(id: :desc)
  end

  def show
    @post = Post.find_by(slug: params[:id])
    render component: 'posts/show', props: { body: @post.body }, prerender: true
  end

  def new
    @user = Current.user
  end

  def create
    post = Current.user.posts.create(
      body: params[:markdown],
      repo: Current.user.repo,
      commit: 'Add another example',
      title: params[:title]
    )

    post.commit_to_github if post
  end
end
