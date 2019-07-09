# typed: ignore
# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate!, only: %i[new create edit]
  before_action :find_blob, only: %i[edit update]

  layout 'editor', only: %i[new edit]

  def index
    @posts = Post.all.limit(20).order(id: :desc)
  end

  def drafts
    published_posts = Post.published.pluck(:blob_id)
    @drafts = Current.user.repository.blobs.reject { |b|  published_posts.include?(b.id) }
  end

  def new
    @post = Post.new(author: Current.user, repository: Current.user.repository)
  end

  def show
    @post = Post.find_by(slug: params[:slug])
    redirect_to root_path if @post.blank?
  end

  def edit
  end

  def create
    repository = Current.user.repository
    next_post_id = repository.posts.maximum(:id)&.next || 1
    blob_id = Rugged::Repository.hash_data(post_params[:body], :blob)

    commit_sha = repository
      .create_commit(message: params[:commit_message], content: post_params[:body], path: "#{next_post_id}-post.md")

    if commit_sha
      render json: { redirect: edit_post_path(slug: blob_id), url: post_path(slug: blob_id), slug: blob_id }
    else
      render json: { errors: post.errors.full_messages }, status: 422
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
      @post.repository.create_commit(committer: Current.user, message: params[:commit_message], action: :remove)

      redirect_to root_path
    else
      redirect_to post_path(@post)
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :summary, :topics, :published_at, :body, :status, :parent)
  end

  def find_blob
    @post = Current.user.repository.find_blob(params[:slug])
  end
end
