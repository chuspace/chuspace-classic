# typed: ignore
# frozen_string_literal: true

class Post < ApplicationRecord
  include AASM

  belongs_to :author, class_name: 'User'
  belongs_to :repository

  has_ancestry
  has_logidze

  enum status: { draft: 0, published: 1, archived: 2 }

  validates_presence_of :slug, :blob_path, :status
  validates_presence_of :title, :summary, :topics, :body, :published_at, :blob_id, if: :published?
  validates_length_of :title, :slug, maximum: 100, if: :published?
  validates_length_of :summary, maximum: 140, if: :published?
  validates_length_of :topics, maximum: 5, if: :published?

  validates_uniqueness_of :slug, scope: %i[repository]
  validates_uniqueness_of :blob_path, scope: %i[repository]

  validates :slug, format: { with: /\A^[a-z0-9]+(?:-[a-z0-9]+)*$\z/i }
  validates :published_at, date: true, if: :published?

  delegate :content, to: :blob, prefix: true

  DEFAULT_TITLE = 'Untitled'
  ROOT_PATH = 'posts/.keep'

  aasm column: :status, enum: true do
    state :draft, initial: true
    state :published, :archived

    event :publish do
      transitions from: :draft, to: :published
    end

    event :archive do
      transitions from: :published, to: :archived
    end

    event :unpublish do
      transitions from: :published, to: :draft
    end
  end

  def blob
    @blob ||= repository.blob_at(path: blob_path)
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

  def outdated?
    blob_id != blob.id
  end

  def published?
    published_at.present?
  end
end
