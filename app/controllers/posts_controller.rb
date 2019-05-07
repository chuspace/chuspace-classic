# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate!, only: %i[new create]
  before_action :find_blog, except: :index
  layout 'editor', only: :new

  def show
    if @blog.present?
      @post = @blog.posts.find_by(slug: params[:slug])
    else
      redirect_to root_path
    end
  end

  def create
    post = Posts::Create.call(user: Current.user, blog: Current.user.default_blog, params: params)

    if post.save
      redirect_to blog_post_path(blog: post.blog.slug, slug: post.slug)
    else
      render json: { errors: post.api_validation_errors }
    end
  end

  def update
    Posts::Update.call(author: author, params: params, committer: Current.user)
  end

  def destroy
    Posts::Destroy.call(params[:id])
  end

  private

  def find_blog
    @blog = Blog.find_by_slug(params[:blog])
  end
end
