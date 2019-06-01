# frozen_string_literal: true

class Post < ApplicationRecord
  class InvalidFrontMatterError < StandardError; end

  include Commitable
  include Blobable # Depends on commitable

  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :author, class_name: 'User'
  belongs_to :repository, autosave: true

  has_ancestry
  has_many_attached :images

  enum status: { draft: 0, published: 1, archived: 2 }

  validates_presence_of :title, :slug, :status
  validates_uniqueness_of :slug, scope: %i[author_id]
  validates :topics, length: { maximum: 3 }

  alias repo repository

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
