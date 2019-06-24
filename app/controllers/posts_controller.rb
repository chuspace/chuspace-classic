# typed: false
# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate!, only: %i[new create edit]
  before_action :find_post, only: %i[edit update]

  layout 'editor', only: %i[new edit]

  def index
    @posts = Post.all.limit(20).order(id: :desc)
  end

  def show
    @post = Post.find_by(slug: params[:id])
    redirect_to root_path if @post.blank?
  end

  def edit; end

  def create
    Post.transaction do
      author = Current.user
      repository = author.repository
      post = repository.posts.build(post_params)
      next_post_id = repository.posts.maximum(:id)&.next || 1
      post.assign_attributes(
        author: author,
        slug: Digest::MD5.hexdigest("#{next_post_id}-#{Current.user.nickname}-post")[0..8],
        blob_path: "#{next_post_id}-post.md"
      )

      commit_message = params[:commit_message] || "Created #{post.blob_path}"

      if post.save
        repository.commit(message: commit_message, content: post.body, path: post.blob_path)
        render json: { redirect: edit_post_path(post), url: post_path(post) }
      else
        render json: { errors: post.errors.full_messages }, status: 422
      end
    end
  end

  def update
    @post.assign_attributes(post_params)
    commit_message = params[:commit_message] || "Updated #{@post.blob_path}"

    if @post.save
      @post.repository.commit(message: commit_message, content: @post.body, path: @post.blob_path)

      render json: { saved: true }
    else
      render json: { errors: @post.errors.full_messages }
    end
  end

  def destroy
    if @post.destroy
      commit_message = params[:commit_message] || "Deleted #{@post.blob_path}"
      @post.repository.commit(committer: Current.user, message: commit_message, action: :remove)

      redirect_to root_path
    else
      redirect_to post_path(@post)
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
