# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate!, only: [:new, :create]
  layout 'editor', only: :new

  def index
    @posts = Post.all.order(id: :desc)
    render component: 'posts/index', props: { posts: @posts }
  end

  def show
    @post = Post.find_by(slug: params[:id])
    render component: 'posts/show', props: { body: @post.body }
  end

  def new
    render component: 'posts/new', props: { user: {
        name: Current.user.name,
        avatar: url_for(Current.user.avatar),
        company: Current.user.company,
        bio: Current.user.bio
    } }, prerender: false
  end

  def create
    post = Current.user.posts.create(
      body: params[:markdown],
      repo: Current.user.repo,
      commit: 'Add another example',
      title: 'Isomorphic readme'
    )

    post.commit_to_github if post
  end
end
