# typed: ignore
# frozen_string_literal: true

class Posts::PublishController < ApplicationController
  before_action :authenticate!
  before_action :find_publication, :find_post, :assign_attributes

  def index
    authorize! ::Posts::Publish, context: { post: @post }
    @published_posts = @publication.posts.published.where.not(id: @post.id)
  end

  def create
    @post.transaction do
      @post.assign_attributes(publish_params)
      @post.assign_attributes(status: 'published', published_at: Time.now) if @post.may_publish?
      @post.assign_attributes(blob_id: @post.blob.oid, body_html: @markdown.body_html)

      authorize! ::Posts::Publish, context: { post: @post }

      respond_to do |format|
        if @post.save
          if @post.saved_change_to_blob_path?
            @post.blob.rename(
              committer: Current.user, new_path: @post.blob_path, commit_message: "Publish post #{@post.blob_path}"
            )
          end

          @post.update(commit_sha: @publication.repository.commit_sha)
          @publication.repository.tags.create(
            @publication.repository.short_sha,
            @publication.repository.commit_sha,
            message: "Publish post #{@post.blob_path}",
            tagger: { name: Current.user.name, email: Current.user.email, time: Time.now }
          )

          format.html { redirect_to publication_post_path(@publication, @post) }
        else
          format.js
          format.html do
            redirect_to publication_post_publish_index_path(@publication, @post),
                        notice: @post.errors.messages.to_sentence
          end
        end
      end
    end
  end

  private

  def publish_params
    params.require(:post).permit(:parent, :canonical_url, topics: [])
  end

  def assign_attributes
    @markdown = PostMarkdownService.call(content: @post.blob_content)
    @post.assign_attributes(title: @markdown.title, summary: @markdown.summary)
    @post.preview_image_remote_url = @markdown.preview_image if @markdown.preview_image.present?
  end

  def find_publication
    @publication = Publication.friendly.find(params[:publication_slug])
  end

  def find_post
    @post = @publication.posts.friendly.find(params[:post_slug])
  end
end
