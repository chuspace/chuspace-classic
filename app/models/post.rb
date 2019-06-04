# frozen_string_literal: true

class Post < ApplicationRecord
  SLUG_FORMAT = /^[a-z0-9]+(?:-[a-z0-9]+)*$/

  belongs_to :author, class_name: 'User'
  belongs_to :repository, autosave: true

  has_ancestry
  has_many_attached :images

  enum status: { draft: 0, published: 1, archived: 2 }

  validates_presence_of :status
  validates :title, :slug, length: { in: 10..100 }, allow_blank: true
  validates :slug, format: { with: Regexp.new('\A' + SLUG_FORMAT.source + '\z') }, allow_blank: true
  validates :excerpt, :slug, length: { in: 0..140 }, allow_blank: true
  validates_uniqueness_of :slug, scope: %i[author_id]
  validates :topics, length: { maximum: 3 }, allow_blank: true
  validates :published_at, date: { allow_nil: true }

  alias repo repository

  def to_param
    slug || blob_name
  end

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
    opts = { autolink: true, fenced_code_blocks: true, disable_indented_code_blocks: true, strikethrough: true }
    markdown = ::Redcarpet::Markdown.new(Redcarpet::Render::HTML, **opts)
    markdown.render(body).html_safe
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
            commit: { message: message || "Created post #{blob_name}" }, file: { content: body, path: blob_name }
          }
        )

      self.save
    end
  end

  def self.sync_from_repo(author:, repository:, commit_sha: nil)
    Post.transaction do
      old_rugged_commit = repository.commit
      new_rugged_commit = commit_sha ? repository.lookup(commit_sha) : repository.head.target
      diff = old_rugged_commit.diff(new_rugged_commit)

      diff.deltas.each do |delta|
        next unless delta.new_file[:path].ends_with?('.md')

        blob = repository.find_blob(delta.new_file[:oid])
        body = blob&.content
        old_name = delta.old_file[:path]
        new_name = delta.new_file[:path]

        case delta.status
        when :added
          repository.posts.create(author: author, blob_name: new_name, body: body)
        when :renamed, :modified
          post = repository.posts.find_by(author: author, blob_name: old_name)
          post.update(body: body, blob_name: new_name)
        when :deleted
          repository.posts.find_by(author: author, blob_name: old_name).destroy
        end
      end

      repository.update(commit_sha: commit_sha)
    end
  end
end
