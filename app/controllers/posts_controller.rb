# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate!, only: %i[new create]
  before_action :find_post, except: :index

  layout 'editor', only: %i[new edit]

  def index
    @posts = Post.all.limit(20).order(id: :desc)
  end

  def show
    @post = Post.find_by(slug: params[:slug])
    redirect_to root_path if @post.blank?
  end

  def edit
  end

  def create
    Post.transaction do
      author = Current.user
      repository = author.repository
      post = repository.posts.build(post_params)
      post.assign_attributes(author: author)

      if post.save
        repository.commit(message: params[:commit_message], content: post.body, path: post.blob_path)
        redirect_to post_show_path(Current.user, post)
      else
        render json: { errors: post.errors.full_messages }, status: 422
      end
    end
  end

  def update
    @post.assign_attributes(post_params)

    if @post.save
      @post.repository.commit(message: params[:commit_message], content: blob_params[:body], path: blob_params[:path])

      redirect_to post_show_path(nickname: Current.user.nickname, slug: @post.slug)
    else
      render json: { errors: post.errors.full_messages }
    end
  end

  def destroy
    if @post.destroy
      @post.repository.commit(committer: Current.user, message: params[:commit_message])

      redirect_to root_path
    else
      redirect_to post_show_path(nickname: Current.user.nickname, slug: @post.slug)
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :slug, :excerpt, :topics, :published_at, :status, :parent, :body)
  end

  def find_post
    @post = Post.find_by(slug: params[:id])
  end
end
