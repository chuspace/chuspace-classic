# typed: ignore
# frozen_string_literal: true

class Posts::PublishController < ApplicationController
  before_action :authenticate!
  before_action :find_post, :assign_attributes, only: %i[index create]

  def index
    @published_posts = Current.user.posts.published.where.not(id: @post.id)
    render 'posts/edit'
  end

  def create
    @post.topics = publish_params[:topics]&.split(',')
    @post.parent = publish_params[:parent]
    @post.assign_attributes(status: 'published', published_at: Time.now) if @post.may_publish?
    new_blob_path = Pathname.new(@post.repo_dir).join("#{@post.slug}.md").to_path

    @post.assign_attributes(
      blob_id: @post.blob.oid, slug: @markdown.title, body_html: @markdown.body_html, blob_path: new_blob_path
    )

    if @post.save
      if @post.blob_path_previously_changed?
        @post.blob.rename(
          committer: Current.user, new_path: new_blob_path, commit_message: "Publish post #{new_blob_path}"
        )
      end
      redirect_to publication_post_path(@post.publication, @post)
    else
      @post.reload
      puts @post.errors.inspect
      render 'posts/edit'
    end
  end

  private

  def publish_params
    params.require(:post).permit(:parent, :topics, :canonical_url)
  end

  def assign_attributes
    @markdown = PostMarkdownService.call(content: @post.blob_content)
    @post.assign_attributes(title: @markdown.title, summary: @markdown.summary)
  end

  def find_post
    @post = Current.user.posts.find_by(slug: params[:post_slug])
  end
end
