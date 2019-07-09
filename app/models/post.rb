# typed: ignore
# frozen_string_literal: true

class Post < ApplicationRecord
  SLUG_FORMAT = /^[a-z0-9]+(?:-[a-z0-9]+)*$/

  belongs_to :author, class_name: 'User'
  belongs_to :repository

  has_ancestry
  enum status: { draft: 0, published: 1, archived: 2 }

  validates_presence_of :title, :slug, :status, :topics, :blob_path
  validates_length_of :title, :slug, maximum: 100
  validates :slug, format: { with: Regexp.new('\A' + SLUG_FORMAT.source + '\z') }
  validates :summary, :slug, length: { maximum: 140 }
  validates_uniqueness_of :slug, scope: %i[repository_id]
  validates_uniqueness_of :blob_path, scope: %i[repository_id]
  validates :topics, length: { maximum: 3 }
  validates :published_at, date: true

  before_validation :assign_defaults

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

  def body_html
    @body_html ||= FastMarkdown.to_html(body).html_safe
  end
end
