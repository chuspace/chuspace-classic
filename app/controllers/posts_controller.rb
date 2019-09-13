# typed: ignore
# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate!, except: %i[show]
  before_action :find_publication
  before_action :find_post, except: %i[show index new create]
  skip_verify_authorized only: :show

  def new
    @post = Post.new(author: Current.user)
    authorize! @post
  end

  def show
    @author = Publication.find_by!(slug: params[:publication_slug])
    @post = @author.posts.find_by!(slug: params[:slug])

    redirect_to edit_post_path(@post) if @post.draft?
  end

  def edit
    authorize! @post
  end

  def create
    Post.transaction do
      markdown = PostMarkdownService.call(content: post_params[:body])
      slug = markdown.title&.to_slug&.to_ascii&.normalize&.to_s
      post = Current.user.posts.build(publication: @publication, slug: slug)
      authorize! post
      post.blob_path = post.repo_dir.join("#{slug}.md").to_path
      blob = @publication.repository.create_blob(path: post.blob_path, content: markdown.content)

      if blob.persisted? && post.save
        render json: {
                 redirect: edit_publication_post_path(@publication, post),
                 slug: post.slug,
                 header:
                   render_to_string(
                     partial: 'posts/header/edit',
                     format: :html,
                     layout: false,
                     locals: { post: post, publication: @publication, params: params }
                   )
               }
      else
        render json: { created: false, message: blob.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    end
  end

  def destroy
    if @post.blob.destroy(committer: Current.user) && @post.destroy
      redirect_to user_drafts_path(@post.author)
    else
      redirect_to post_path(@post)
    end
  end

  private

  def post_params
    params.require(:post).permit(:body)
  end

  def find_publication
    @publication = Publication.find_by!(slug: params[:publication_slug])
  end

  def find_post
    @post = Post.find_by!(slug: params[:slug])
  end
end
