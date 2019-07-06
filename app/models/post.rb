# typed: ignore
# frozen_string_literal: true

require 'redcarpet/render_strip'

class Post < ApplicationRecord
  SLUG_FORMAT = /^[a-z0-9]+(?:-[a-z0-9]+)*$/

  belongs_to :author, class_name: 'User'
  belongs_to :repository

  has_ancestry
  enum status: { draft: 0, published: 1, archived: 2 }

  validates_presence_of :slug, :status, :blob_path
  validates_length_of :title, :slug, maximum: 100, allow_blank: true, allow_nil: true
  validates :slug, format: { with: Regexp.new('\A' + SLUG_FORMAT.source + '\z') }
  validates :summary, :slug, length: { maximum: 140 }, allow_blank: true, allow_nil: true
  validates_uniqueness_of :slug, scope: %i[repository_id]
  validates_uniqueness_of :blob_path, scope: %i[repository_id]
  validates :topics, length: { maximum: 3 }, allow_blank: true
  validates :published_at, date: { allow_nil: true }

  alias repo repository

  def blob
    @blob ||= repository.blob_at(path: blob_path)
  end

  def blob_oid
    @blob_oid ||= Rugged::Repository.hash_data(body || '', :blob)
  end

  def outdated?
    blob_oid != blob.id
  end

  def self.url_for(blob_path)
    blob_path = blob_path[1..-1] if blob_path.starts_with?('/')
    post = find_by(blob_path: blob_path)

    if post
      author = post.author
      Rails.application.routes.url_helpers.post_path(post)
    else
      blob_path
    end
  end

  def to_param
    slug
  end

  def topics=(val)
    super(val&.map { |topic| FastSlug.generate(topic) })
  end

  def parent=(val)
    case val
    when String
      super(Post.find_by_slug(Slug.generate(val)))
    when Post
      val
    else
      nil
    end
  end

  def draft_body
    blob.safe_content
  end

  def draft_body_html
    @draft_body_html ||= markdown_renderer.render(draft_body).html_safe
  end

  def body_html
    @body_html ||= markdown_renderer.render(body).html_safe
  end

  def title
    renderer = Redcarpet::Markdown.new(Redcarpet::Render::StripDown)
    super || renderer.render(body || blob&.safe_content || '')[0..100]
  end

  private

  def markdown_renderer
    @renderer ||=
      Redcarpet::Markdown.new(
        Redcarpet::Render::HTML.new(filter_html: true, safe_links_only: true),
        fenced_code_blocks: true,
        disable_indented_code_blocks: true,
        autolink: true,
        strikethrough: true,
        space_after_headers: true
      )
  end
end
