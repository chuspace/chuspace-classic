# typed: ignore
# frozen_string_literal: true

class Posts::PublishController < ApplicationController
  before_action :authenticate!
  before_action :find_post, :assign_attributes, only: %i[index create]

  layout 'editor', only: :index

  def index
    @published_posts = Current.user.posts.where.not(id: @post.id)
    render 'posts/edit'
  end

  def create
    @post.topics = publish_params[:topics]&.split(',')
    @post.parent = publish_params[:parent]
    @post.blob_id = @post.blob.oid
    @post.slug = @markdown.title
    @post.assign_attributes(body_html: @markdown.body_html)

    if @post.may_publish?
      @post.publish
      @post.assign_attributes(published_at: Time.now)
    end

    if @post.save
      redirect_to post_path(@post)
    else
      render :index
    end
  end

  private

  def publish_params
    params.require(:post).permit(:parent, :topics)
  end

  def assign_attributes
    @markdown = PostMarkdownService.call(content: @post.blob_content)
    @post.assign_attributes(title: @markdown.title, summary: @markdown.summary)
  end

  def find_post
    @post = Current.user.posts.find_by(slug: params[:post_slug])
  end
end
