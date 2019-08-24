# typed: ignore
# frozen_string_literal: true

class Post < ApplicationRecord
  include AASM

  db_belongs_to :author, class_name: 'User'
  db_belongs_to :publication

  has_ancestry
  has_logidze

  enum status: { draft: 0, published: 1 }

  validates_presence_of :slug, :blob_path, :status
  validates_presence_of :title, :summary, :topics, :body_html, :published_at, :blob_id, if: :published?
  validates_length_of :title, :slug, maximum: 100, if: :published?
  validates_length_of :summary, maximum: 140, if: :published?
  validates_length_of :topics, maximum: 5, if: :published?

  validates_db_uniqueness_of :slug, scope: %i[publication_id]
  validates_db_uniqueness_of :blob_path, scope: %i[publication_id]

  validates :slug, format: { with: /\A^[a-z0-9]+(?:-[a-z0-9]+)*$\z/i }
  validates :published_at, date: true, if: :published?

  delegate :content, to: :blob, prefix: true

  DEFAULT_TITLE = 'Untitled'

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

  def blob
    @blob ||= publication.repository.blob_at(path: blob_path)
  end

  def to_param
    slug
  end

  def slug=(val)
    super(val&.to_slug&.to_ascii&.normalize&.to_s)
  end

  def topics=(val)
    super(val&.map { |topic| topic&.to_slug&.to_ascii&.normalize&.to_s })
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

  def title
    super || draft.title || DEFAULT_TITLE
  end

  def summary
    super || draft.summary
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

  def topics_list
    topics&.join(',')
  end

  def publish_label
    published? ? 'Republish' : 'Publish'
  end

  def status_label
    new_record? ? 'New' : 'Saved'
  end

  def tree
    post_tree = [self] + ancestors.published + descendants.published

    Post.sort_by_ancestry(post_tree) do |a, b|
      [a.published_at, a.title] <=> [b.published_at, b.title]
    end
  end

  def repo_dir
    dir = case status.to_sym
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
      'theme-color': '#000000',
      canonical: canonical_url || Rails.application.routes.url_helpers.user_post_url(author, self),
      og: {
        title: :title,
        type: :article,
        description: :description,
        site_name: :site,
        url: Rails.application.routes.url_helpers.user_post_url(author, self)
      },
      twitter: {
        title: :title,
        card: :summary,
        description: :description,
        site_name: :site
      },
      article: {
        published_time: published_at,
        modified_time: updated_at,
        tag: topics_list,
        author: author.nickname
      }
    }
  end
end
