# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :author, class_name: 'User'

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

  enum status: { draft: 0, published: 0, archived: 1 }

  validates_presence_of :title, :slug, :status
  validates_presence_of :blob_id, :commit_sha, on: :update

  def blob
    author.blog.find_blob(blob_id)
  end

  def commit
    author.blog.find_commit(commit_sha)
  end

  def blob_content
    frontmatter + "\n" + body
  end

  def frontmatter
    "---\n" + %w[title slug excerpt tags status published_at].map do |attribute|
      "#{attribute}: #{send(attribute)}"
    end.join("\n") + "\n---"
  end
end
