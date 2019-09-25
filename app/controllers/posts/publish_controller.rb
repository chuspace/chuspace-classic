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
      @post.valid?

      new_blob_path = Pathname.new(@post.repo_dir).join("#{@post.slug}.md").to_path
      @post.assign_attributes(blob_id: @post.blob.oid, body_html: @markdown.body_html, blob_path: new_blob_path)

      authorize! ::Posts::Publish, context: { post: @post }

      if @post.save
        if @post.saved_change_to_blob_path?
          @post.blob.rename(
            committer: Current.user, new_path: new_blob_path, commit_message: "Publish post #{new_blob_path}"
          )
        end

        redirect_to publication_post_path(@post.publication, @post)
      else
        @post.reload
        render 'posts/edit', turbolinks: true
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
    @publication = Current.user.publications.friendly.find(params[:publication_slug])
  end

  def find_post
    @post = @publication.posts.friendly.find(params[:post_slug])
  end
end
