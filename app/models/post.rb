# typed: ignore
# frozen_string_literal: true

class Post < ApplicationRecord
  include AASM, Topicable, Slugable

  has_ancestry
  has_logidze
  sluggable :title

  enum status: { draft: 0, published: 1 }

  validates_presence_of :slug, :blob_path, :status
  validates_presence_of :title, :topics, :body_html, :published_at, :blob_id, if: :published?
  validates_length_of :title, :slug, maximum: 100, if: :published?
  validates_length_of :summary, maximum: 140, if: :published?, allow_blank: true

  validates_db_uniqueness_of :slug, scope: %i[publication_id]
  validates_db_uniqueness_of :blob_path, scope: %i[publication_id]

  has_many :likes, dependent: :destroy
  db_belongs_to :author, class_name: 'User', foreign_key: :author_id, counter_cache: true, touch: true
  db_belongs_to :publication, counter_cache: true, touch: true

  validates :canonical_url, url: true, allow_blank: true
  validates :published_at, date: true, if: :published?

  delegate :content, to: :blob, prefix: true

  scope :frontpage, -> { published.where(unlisted: false) }

  DEFAULT_TITLE = 'Untitled'
  WORDS_PER_MINUTE = 200

  aasm column: :status, enum: true do
    state :draft, initial: true
    state :published

    event :publish do
      transitions from: :draft, to: :published
    end

    event :unpublish do
      transitions from: :published, to: :draft
    end
  end

  def self.autocomplete_search(query:)
    sql = <<-SQL
      unaccent(posts.title) ILIKE unaccent('%#{query}%') OR
      unaccent(posts.slug) ILIKE unaccent('%#{
      query
    }%')
    SQL

    published.where(sql)
  end

  def published_blob
    @published_blob ||= publication.repository.lookup(blob_id)
  end

  def blob
    @blob ||= publication.repository.blob_at(path: blob_path)
  end

  def parent=(val)
    case val
    when String
      super(Post.find_by_slug(val))
    when Post
      val
    else
      nil
    end
  end

  def can_edit?(user:)
    collaborator ||= publication.collaborators.find_by(user: user)
    author == user || collaborator && collaborator.role != Collaborator::WRITER_ROLE
  end

  def title
    super || draft.title.presence&.squish || DEFAULT_TITLE
  end

  def summary
    super || draft.summary.presence&.squish
  end

  def outdated?
    blob_id != blob.oid
  end

  def published?
    published_at.present?
  end

  def formatted_published_at
    published_at.strftime('%b %d, %Y')
  end

  def words_count
    published_blob&.content&.scan(/\w+/)&.size || 0
  end

  def reading_time
    (words_count / WORDS_PER_MINUTE).round
  end

  def publish_label
    published? ? 'Republish' : 'Publish'
  end

  def status_label
    new_record? ? 'New' : 'Saved'
  end

  def tree
    post_tree = [self] + ancestors.published + descendants.published

    Post.sort_by_ancestry(post_tree) { |a, b| [a.published_at, a.title] <=> [b.published_at, b.title] }
  end

  def repo_dir
    dir =
      case status.to_sym
      when :draft
        Repository::DRAFTS_ROOT_PATH
      when :published
        Repository::POSTS_ROOT_PATH
      end

    Pathname.new(dir)
  end

  def draft
    @draft ||= PostMarkdownService.call(content: blob.content)
  end

  def to_meta_tags
    {
      site: 'Chuspace',
      charset: 'en',
      title: title,
      description: summary,
      keywords: topics_list,
      index: true,
      follow: true,
      author: author.name,
      canonical: canonical_url || Rails.application.routes.url_helpers.publication_post_url(author, self),
      og: {
        title: :title,
        type: :article,
        description: :description,
        site_name: :site,
        url: Rails.application.routes.url_helpers.publication_post_url(author, self)
      },
      twitter: { title: :title, card: :summary, description: :description, site_name: :site },
      article: { published_time: published_at, modified_time: updated_at, tag: topics_list, author: author.nickname }
    }
  end

  def liked_by?(user:)
    likes.where(user: user).exists?
  end
end
