# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate!, only: %i[new create]
  before_action :find_blog, except: :index
  layout 'editor', only: :new

  def index
    @posts = Post.all.limit(20)
  end

  def show
    @post = Post.find_by(slug: params[:slug])
    redirect_to root_path if @post.blank?
  end

  def create
    post =
      Post.commit_and_create_by(
        author: Current.user, committer: Current.user, blog: Current.user.default_blog, attrs: post_params
      )

    if post.persisted?
      redirect_to blog_post_path(blog: post.blog.slug, slug: post.slug)
    else
      render json: { errors: post.errors.full_messages }
    end
  end

  def update
    Posts::Update.call(author: author, params: params, committer: Current.user)
  end

  def destroy
    Posts::Destroy.call(params[:id])
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

  def find_blog
    @blog = Blog.find_by_slug(params[:blog])
  end
end
