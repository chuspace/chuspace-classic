# typed: ignore
# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate!, except: %i[show]
  before_action :find_post, except: %i[show index new create]
  after_action :verify_authorized, only: %[new edit create]

  layout 'editor', only: %i[new edit]

  def new
    @post = Post.new(author: Current.user)
  end

  def show
    @author = User.find_by!(nickname: params[:user_nickname])
    @post = @author.posts.find_by!(slug: params[:slug])

    redirect_to edit_post_path(@post) if @post.draft?
  end

  def edit
    authorize @post
  end

  def create
    Post.transaction do
      markdown = PostMarkdownService.call(content: post_params[:body])
      slug = markdown.title&.to_slug&.to_ascii&.normalize&.to_s
      blob_path = File.join(Repository::POSTS_ROOT, "#{slug}.md")
      blob = Current.user.repository.create_blob(path: blob_path, content: markdown.content)

      if blob.persisted?
        post = Current.user.posts.create(repository: Current.user.repository, slug: blob.oid[0..8], blob_path: blob_path)

        render json: {
          redirect: edit_post_path(post),
          slug: post.slug,
          header: render_to_string(
            partial: 'posts/header/edit',
            format: :html,
            layout: false,
            locals: { post: post, params: params }
          )
        }
      else
        render json: { created: false, message: blob.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    end
  end

  def destroy
    if @post.blob.destroy && @post.destroy
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
