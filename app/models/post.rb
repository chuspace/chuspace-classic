# frozen_string_literal: true

class Post < ApplicationRecord
  class InvalidFrontMatterError < StandardError; end
  SLUG_FORMAT = /^[a-z0-9]+(?:-[a-z0-9]+)*$/

  include Blobable

  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :author, class_name: 'User'
  belongs_to :repository, autosave: true

  has_ancestry
  has_many_attached :images

  enum status: { draft: 0, published: 1, archived: 2 }

  validates_presence_of :title, :slug, :status
  validates :title, :slug, length: { in: 10..100 }
  validates :slug, format: { with: Regexp.new('\A' + SLUG_FORMAT.source + '\z') }
  validates :excerpt, :slug, length: { in: 0..140 }, allow_blank: true
  validates_uniqueness_of :slug, scope: %i[author_id]
  validates :topics, length: { maximum: 3 }, allow_blank: true
  validates :published_at, date: { allow_nil: true }

  alias repo repository

  def topics=(val)
    super(topics&.map(&:parameterize))
  end

  def parent_slug
    parent&.slug
  end

  def parent_slug=(slug)
    self.parent = Post.find_by_slug(slug)
  end

  def body_html
    body
  end

  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end

  def commit_to_repo_and_save(message: nil, action: :add)
    self.repository = author.repository

    if valid?
      self.blob_name = "#{slug}.md"

      author.repository.commit_sha =
        Git::Commit.create(
          repository: repo,
          committer: author,
          action: action,
          options: {
            commit: { message: message || "Created post #{blob_name}" },
            file: { content: blob_content, path: blob_name }
          }
        )

      self.save
    end
  end
end
