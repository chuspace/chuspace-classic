# frozen_string_literal: true

class Blog < ApplicationRecord
  include GitRepo, Sluggable
  sluggable :name

  validates :name, :slug, :repo_name, presence: true
  validates_uniqueness_of :slug, scope: :author_id

  enum status: { draft: 0, published: 1, archived: 2 }

  belongs_to :author, class_name: 'User'
  has_many :posts

  before_validation :assign_slug

  def to_param
    slug
  end

  private

  def assign_slug
    self.slug = self.name&.parameterize&.downcase&.strip
  end
end
