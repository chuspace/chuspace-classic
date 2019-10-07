# typed: ignore
# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate!, except: %i[show]
  before_action :find_publication
  before_action :find_post, except: %i[index new create]
  skip_verify_authorized only: :show
  after_action :track_action, only: :show

  def new
    @post = Post.new(author: Current.user)
    authorize! @post
  end

  def show
    @headroom = true

    if request.path != publication_post_path(@publication, @post)
      return redirect_to publication_post_path(@publication, @post), status: :moved_permanently
    end

    redirect_to edit_publication_post_path(@publication, @post) if @post.draft?
  end

  def edit
    authorize! @post
  end

  def create
    Post.transaction do
      markdown = PostMarkdownService.call(content: post_params[:body])
      post = Current.user.posts.build(publication: @publication, title: markdown.title)
      authorize! post

      if post.save
        blob = @publication.repository.create_blob(path: post.blob_path, content: markdown.content)

        if blob&.persisted?
          render json: {
                   redirect: edit_publication_post_path(@publication, post),
                   id: post.slug,
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
      else
        render json: { created: false, message: post.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    end
  end

  def destroy
    authorize! @post

    if @post.destroy && @post.blob.destroy(committer: Current.user)
      redirect_to publication_path(@publication)
    else
      redirect_to publication_post_path(@publication, @post)
    end
  end

  private

  def post_params
    params.require(:post).permit(:body)
  end

  def find_publication
    @publication = Publication.friendly.find(params[:publication_slug])
  end

  def find_post
    @post = @publication.posts.friendly.find(params[:slug])
  end

  def track_action
    ahoy.track 'Viewed post', request.path_parameters.merge(post_id: @post.id, publication_id: @publication.id)
  end
end
