# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate!, only: %i[new create]
  before_action :find_post, except: :index

  layout 'editor', only: :new

  def index
    @posts = Post.all.limit(20)
  end

  def show
    @post = Post.find_by(slug: params[:slug])
    redirect_to root_path if @post.blank?
  end

  def create
    post = Post.commit_and_create_by(author: Current.user, committer: Current.user, attrs: post_params)

    if post.persisted?
      redirect_to post_show_path(nickname: Current.user.nickname, slug: post.slug)
    else
      render json: { errors: post.errors.full_messages }
    end
  end

  def update
    @post.update(post_params)
    @post.commit_and_save(committer: Current.user)
    redirect_to post_show_path(nickname: Current.user.nickname, slug: @post.slug)
  end

  def destroy
    @post.commit_and_destroy
    redirect_to root_path
  end

  private

  def post_params
    params.require(:post).permit(
      :title,
      :slug,
      :excerpt,
      :body,
      :tag_slugs,
      :published_at,
      :status,
      :parent_slug,
      :visibility
    )
  end

  def find_post
    @post = Post.find_by(slug: params[:slug])
  end
end
