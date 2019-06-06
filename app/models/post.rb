# frozen_string_literal: true

require 'mimemagic'

class Post < ApplicationRecord
  SLUG_FORMAT = /^[a-z0-9]+(?:-[a-z0-9]+)*$/

  belongs_to :author, class_name: 'User'
  belongs_to :repository, autosave: true
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
    Markdown.to_html(body).html_safe
  end

  def self.sync_from_repo(author:, repository:, commit_sha: nil)
    Post.transaction do
      old_rugged_commit = repository.commit
      new_rugged_commit = commit_sha ? repository.lookup(commit_sha) : repository.head.target
      diff = old_rugged_commit.diff(new_rugged_commit)

      diff.deltas.each do |delta|
        mime = MimeMagic.by_path(delta.new_file[:path])
        next unless mime.text?

        old_name = delta.old_file[:path]
        new_name = delta.new_file[:path]

        case delta.status
        when :added
          repository.posts.create!(author: author, blob_name: new_name)
        when :renamed, :modified
          post = repository.posts.find_by(author: author, blob_name: old_name)
          post.update!(blob_name: new_name)
        when :deleted
          repository.posts.find_by(author: author, blob_name: old_name)&.destroy
        end
      end

      repository.update(commit_sha: commit_sha || new_rugged_commit.oid)
    end
  end

  private

  def assign_slug
    self.title = Markdown.title(body || '') if title.blank?
    self.slug = title ? Slug.generate(title) : SecureRandom.uuid
  end
end
