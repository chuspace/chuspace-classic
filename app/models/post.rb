# frozen_string_literal: true

class Post < ApplicationRecord
  class InvalidFrontMatterError < StandardError; end

  include Commitable
  include Blobable # Depends on commitable

  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :author, class_name: 'User'

  has_many :taggings
  has_many :tags, through: :taggings
  has_many :contributions
  has_many :contributors, through: :contributions, source: :contributor

  has_ancestry
  has_many_attached :images

  enum status: { draft: 0, published: 1, archived: 2 }

  validates_presence_of :title, :slug, :status, :blob_id
  validates_uniqueness_of :blob_id
  validates_uniqueness_of :slug, scope: %i[author_id]

  delegate :repo, to: :author

  def tag_slugs
    tags.pluck(:slug)
  end

  def tag_slugs=(slugs)
    self.tags = slugs.map { |slug| Tag.where(slug: slug.strip).first_or_create! }
  end

  def parent_slug
    parent&.slug
  end

  def parent_slug=(slug)
    self.parent = Post.find_by_slug(slug)
  end

  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end
end
