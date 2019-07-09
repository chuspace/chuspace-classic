# typed: ignore
# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :blob

  has_ancestry
  has_logidze

  validates_presence_of :title, :summary, :slug, :topics, :blob_id, :body, :published_at
  validates_length_of :title, :slug, maximum: 100
  validates_length_of :summary, maximum: 140
  validates_length_of :topics, maximum: 5

  validates_uniqueness_of :slug, scope: %i[author_id]
  validates_uniqueness_of :blob_id, scope: %i[author_id]

  validates :slug, format: { with: /\A^[a-z0-9]+(?:-[a-z0-9]+)*$\z/i }
  validates :published_at, date: true

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
end
