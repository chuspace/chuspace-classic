# typed: ignore
# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :author, class_name: 'User'

  has_ancestry
  has_logidze

  validates_presence_of :slug, :blob_path
  validates_presence_of :title, :summary, :topics, :body, :published_at, if: :published?
  validates_length_of :title, :slug, maximum: 100, if: :published?
  validates_length_of :summary, maximum: 140, if: :published?
  validates_length_of :topics, maximum: 5, if: :published?

  validates_uniqueness_of :slug, scope: %i[author_id]
  validates_uniqueness_of :blob_path, scope: %i[author_id]

  validates :slug, format: { with: /\A^[a-z0-9]+(?:-[a-z0-9]+)*$\z/i }
  validates :published_at, date: true, if: :published?

  def blob
    @blob ||= author.repository.blob_at(path: blob_path)
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
      super(Post.find_by_slug(FastSlug.generate(val)))
    when Post
      val
    else
      nil
    end
  end

  def published?
    published_at.present?
  end
end
