# frozen_string_literal: true

class Post < ApplicationRecord
  SLUG_FORMAT = /^[a-z0-9]+(?:-[a-z0-9]+)*$/

  belongs_to :author, class_name: 'User'
  belongs_to :repository
  belongs_to :blob

  has_ancestry
  enum status: { draft: 0, published: 1, archived: 2 }

  validates_presence_of :title, :slug, :status
  validates :title, :slug, length: { in: 10..100 }
  validates :slug, format: { with: Regexp.new('\A' + SLUG_FORMAT.source + '\z') }
  validates :excerpt, :slug, length: { in: 0..140 }, allow_blank: true
  validates_uniqueness_of :slug, scope: %i[author_id]
  validates :topics, length: { maximum: 3 }, allow_blank: true
  validates :published_at, date: { allow_nil: true }

  delegate :content, to: :blob

  before_validation :assign_slug

  alias repo repository

  def to_param
    slug
  end

  def topics=(val)
    super(val&.map { |topic| Slug.generate(topic) })
  end

  def parent=(val)
    case val
    when String then super(Post.find_by_slug(Slug.generate(val)))
    when Post then val
    else nil
    end
  end

  def body_html
    @body_html ||= Markdown.to_html(content).html_safe
  end

  private

  def assign_slug
    self.title = Markdown.title(content || '') if title.blank?
    self.slug = title ? Slug.generate(title) : SecureRandom.uuid if slug.blank? || slug_changed?
  end
end
