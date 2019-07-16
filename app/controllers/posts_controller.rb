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
      markdown = PostMarkdownService.call(content: post_params[:body])
      post = Current.user.posts.build(repository: Current.user.repository, slug: markdown.slug, blob_path: markdown.blob_path)

      if post.save
        Current.user.repository.create_commit(content: markdown.content, path: post.blob_path)
        render json: {
          redirect: edit_post_path(post),
          slug: post.slug,
          header: render_to_string(
            partial: 'posts/header',
            formats: :html,
            layout: false,
            locals: { post: post }
          )
        }
      else
        render json: { created: false }, status: :unprocessable_entity
      end
    end
  end

  def destroy
    if @post.destroy
      Current.user.repository.create_commit(content: '', path: @post.blob_path, action: :remove)
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
    @post = Post.find_by!(slug: params[:slug])
  end
end
