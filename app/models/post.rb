# frozen_string_literal: true

class Post < ApplicationRecord
  include Sluggable
  sluggable :title

  belongs_to :author, class_name: 'User'
  belongs_to :blog

  has_many :comments
  has_many :likes
  has_many :taggings
  has_many :bookmarks
  has_many :tags, through: :taggings
  has_many :contributions
  has_many :collaborators
  has_many :contributors, through: :contributions, source: :contributor

  has_ancestry

  has_many_attached :images

  enum status: { draft: 0, published: 1, archived: 2 }

  validates_presence_of :title, :slug, :status
  validates_presence_of :blob_id, on: :update
  validates_uniqueness_of :slug, scope: %i[blog_id author_id]

  def blob
    blog.repo.find_blob(blob_id)
  end

  def blob_content
    blob_frontmatter + "\n" + body
  end

  def tag_names
    tags.pluck(:slug)
  end

  def blob_frontmatter
    "---\n" +
      %w[title slug excerpt tag_names status published_at].map { |attribute| "#{attribute}: #{send(attribute)}" }.join(
        "\n"
      ) +
      "\n---"
  end
end
