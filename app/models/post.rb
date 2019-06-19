# frozen_string_literal: true
require 'redcarpet/render_strip'

class Post < ApplicationRecord
  SLUG_FORMAT = /^[a-z0-9]+(?:-[a-z0-9]+)*$/

  belongs_to :author, class_name: 'User'
  belongs_to :repository

  has_ancestry
  enum status: { draft: 0, published: 1, archived: 2 }

  validates_presence_of :slug, :status
  validates :title, :slug, length: { in: 1..100 }, allow_blank: true
  validates :slug, format: { with: Regexp.new('\A' + SLUG_FORMAT.source + '\z') }
  validates :excerpt, :slug, length: { in: 0..140 }, allow_blank: true
  validates_uniqueness_of :slug, scope: %i[author_id]
  validates :topics, length: { maximum: 3 }, allow_blank: true
  validates :published_at, date: { allow_nil: true }

  before_destroy :remove_from_repository

  alias repo repository

  def self.url_for(blob_path)
    blob_path = blob_path[1..-1] if blob_path.starts_with?('/')
    post = find_by(blob_path: blob_path)

    if post
      author = post.author
      Rails.application.routes.url_helpers.post_show_path(author, post)
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
    when String then super(Post.find_by_slug(Slug.generate(val)))
    when Post then val
    else nil
    end
  end

  def body_html
    renderer = Redcarpet::Markdown.new(Redcarpet::Render::HTML, {})
    @body_html ||= renderer.render(body).html_safe
  end

  def title
    renderer = Redcarpet::Markdown.new(Redcarpet::Render::StripDown)
    super || renderer.render(body)[0..100]
  end

  private

  def remove_from_repository
    repository.commit(message: "Deleted #{blob_path}", action: :remove, path: blob_path, content: body)
  end
end
