# typed: ignore
# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate!, except: %i[show]
  before_action :find_post, except: %i[index new]

  layout 'editor', only: %i[new edit]

  def new
    @post = Post.new(author: Current.user)
  end

  def show
    redirect_to root_path if @post.blank?
  end

  def create
    Post.transaction do
      next_post_id = Current.user.posts.maximum(:id)&.next || 1
      name = "#{next_post_id}-#{FastSlug.generate(FastMarkdown.title(post_params[:body] || ''))}"
      oid = Rugged::Repository.hash_data(post_params[:body], :blob)

      @post = Current.user.posts.build(
        slug: oid[0..8],
        blob_path: "#{name}.md"
      )

      if @post.save
        Current.user.repository.create_commit(content: post_params[:body], path: @post.blob_path)
        render json: { redirect: edit_post_path(@post), slug: @post.slug }
      else
        render :new
      end
    end
  end

  def destroy
    if @post.destroy
      redirect_to root_path
    else
      redirect_to post_path(@post)
    end
  end

  private

  def post_params
    params.require(:post).permit(:body)
  end

  def find_post
    @post = Current.user.posts.find_by(slug: params[:slug])
  end
end
