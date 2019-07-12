# typed: ignore
# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate!, except: %i[show]
  before_action :find_post, except: %i[index new create]

  layout 'editor', only: %i[new edit]

  def new
    @post = Post.new(author: Current.user)
  end

  def show
    redirect_to edit_post_path(@post) if @post.draft?
  end

  def create
    Post.transaction do
      name = FastSlug.generate(FastMarkdown.title(post_params[:body])[0..50])
      oid = Rugged::Repository.hash_data(post_params[:body], :blob)

      @post = Current.user.posts.build(
        slug: oid[0..8],
        blob_path: "posts/#{name}.md"
      )

      if @post.save
        Current.user.repository.create_commit(content: post_params[:body], path: @post.blob_path)

        render json: { redirect: edit_post_path(@post), slug: @post.slug }
      else
        render json: { created: false }, status: :unprocessable_entity
      end
    end

  rescue TypeError
    render json: { created: false }, status: :unprocessable_entity
  end

  def destroy
    if @post.destroy
      redirect_to user_drafts_path(@post.author)
    else
      redirect_to post_path(@post)
    end
  end

  private

  def post_params
    params.require(:post).permit(:body)
  end

  def find_post
    @post = Current.user.posts.find_by!(slug: params[:slug])
  end
end
