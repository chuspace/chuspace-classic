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
    Post.transaction do
      author = Current.user
      repository = author.repository
      blob = repository.blobs.build(blob_params)
      post = blob.build_post(post_params)

      post.assign_attributes(author: author, repository: repository)


      if blob.save
        redirect_to post_show_path(Current.user, post)
      else
        render json: { errors: post.errors.full_messages }, status: 422
      end
    end
  end

  def update
    @post.assign_attributes(post_params)

    if post.valid?
      post.commit_sha = post.commit(committer: Current.user, message: params[:commit_message])
      post.save
      redirect_to post_show_path(nickname: Current.user.nickname, slug: @post.slug)
    else
      render json: { errors: post.errors.full_messages }
    end
  end

  def destroy
    if @post.destroy
      @post.commit(committer: committer, message: params[:commit_message], action: :remove)
      redirect_to root_path
    else
      redirect_to post_show_path(nickname: Current.user.nickname, slug: @post.slug)
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :slug, :excerpt, :topics, :published_at, :status, :parent)
  end

  def blob_params
    attrs = params.require(:post).permit(:title, :slug, :body, :commit_message)

    {
      path: attrs[:slug] || Slug.generate(attrs[:title]) || SecureRandom.uuid + '.md',
      blob: StringIO.new(attrs[:body]),
      blob_type: :text,
      commit_message: attrs[:commit_message]
    }.freeze
  end

  def find_post
    @post = Post.find_by(slug: params[:slug])
  end
end
