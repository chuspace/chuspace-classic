# typed: ignore
# frozen_string_literal: true

class Posts::PublishController < ApplicationController
  before_action :authenticate!
  before_action :find_post, :assign_attributes, only: %i[index create]

  layout 'editor', only: :index

  def create
    @post.topics = publish_params[:topics]
    @post.parent = publish_params[:parent]
    @post.blob_id = @post.blob.id

    if @post.save
      @post.publish! if @post.may_publish?
      redirect_to post_path(@post)
    else
      render :index
    end
  end

  private

  def publish_params
    params.require(:post).permit(:parent, topics: [])
  end

  def assign_attributes
    markdown = PostMarkdownService.call(content: @post.blob_content)
    @post.assign_attributes(title: markdown.title, summary: markdown.summary, slug: markdown.slug, body_html: markdown.body_html, published_at: Time.now)
  end

  def find_post
    @post = Current.user.posts.find_by(slug: params[:post_slug])
  end
end
