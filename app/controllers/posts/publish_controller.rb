# typed: ignore
# frozen_string_literal: true

class Posts::PublishController < ApplicationController
  before_action :authenticate!
  before_action :find_post, only: %i[index create]

  def create
    markdown = PostMarkdownService.call(content: @post.blob_content)

    if @post.update(title: markdown.title, summary: markdown.summary, slug: markdown.slug, body_html: markdown.body_html, **publish_params)
      redirect_to post_path(@post)
    else
      redirect_to edit_post_path(@post)
    end
  end

  private

  def publish_params
    params.require(:post).permit(:topics, :published_at, :parent)
  end

  def find_post
    @post = Current.user.posts.find_by(slug: params[:post_slug])
  end
end
