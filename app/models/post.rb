# frozen_string_literal: true

class Post
  class InvalidAuthor < StandardError;  end

  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks
  include ActiveModel::Serialization
  include ActiveModel::Dirty

  STATUSES       = %w[draft published archieved]
  DEFAULT_STATUS = 'draft'

  attr_reader   :errors
  attr_accessor :id, :title, :slug, :filename, :excerpt, :content, :tags,
                :status, :published_at, :author, :author_nickname

  validates_presence_of :title, :slug, :status, :author
  validates_length_of   :title, maximum: 64
  validates_length_of   :slug, maximum: 64

  define_attribute_methods :filename

  delegate :blog, to: :author, allow_nil: true

  def initialize(attributes = {})
    @filename = attributes[:filename]
    @errors   = ActiveModel::Errors.new(self)

    super

    fail InvalidAuthor, 'Author must be supplied' if author.blank?

    @author_nickname = author.nickname
  end

  class << self
    delegate :first, :last, to: :all

    def new_from_es(hash)
      blob = Git::Repository.new(author: author).find_file(filename)
      initialize_from_blob(blob)
    end

    def initialize_from_blob(blob)
      frontmatter = YAML.load(blob.content)
      attrs = frontmatter.merge(
        id: blob.id,
        filename: blob.name,
        author: blob.author,
        content: blob.content.gsub(/---(.|\n)*---/, '')
      )

      post = new(attrs)
      post.slug ||= post.filename
      post
    end

    def initialize_from_blob!(raw_content)
      initialize_from_blob(raw_content).validate!
    end

    def all
      @all ||= Person.all.flat_map do |person|
        person.all_posts
      end
    end

    def find(author: Current.person, filename:)
      blob = Git::Repository.new(author: author).find_file(filename)
      initialize_from_blob(blob) if blob
    end

    def exists?(filename:)
      all.any? { |post| post.filename === filename }
    end

    def reload
      @all = nil
    end
  end

  def filename=(new_filename)
    filename_will_change! unless @filename == new_filename
    @filename = new_filename
  end

  def add(commit_message: "Created #{filename}", branch: 'master')
    if non_unique?
      errors.add(:filename, 'already exists')
      return false
    end

    blob = blog.create_commit(
      commit: {
        message: commit_message,
        branch: branch
      },
      file: {
        content: raw_content,
        path: filename
      }
    )

    if blob
      post    = self.class.initialize_from_blob(blob)
      self.id = post.id

      elasticsearch_repo.save(post)
      changes_applied
      post
    end
  end

  def update(commit_message: "Update #{filename}", branch: 'master')
    previous_path = nil
    action = :update

    if filename_changed?
      action        = :rename
      previous_path = filename_was
    end

    if non_unique?
      errors.add(:filename, 'already exists')
      return false
    end

    blob = blog.create_commit(
      {
        commit: {
          message: commit_message,
          branch: branch
        },
        file: {
          content: raw_content,
          path: filename,
          previous_path: previous_path
        }
      },
      action
    )

    if blob
      post = self.class.initialize_from_blob(blob)

      elasticsearch_repo.delete(self) if self.id != post.id
      elasticsearch_repo.save(post)

      changes_applied
      post
    end
  end

  def remove(branch: 'master')
    removed = blog.create_commit(
      {
        commit: {
          message: "Deleted #{filename}",
          branch: branch
        },
        file: {
          path: filename
        }
      },
      :remove
    )

    elasticsearch_repo.delete(id) if removed
    removed
  end

  def contributors
    emails = Rugged::Blame.new(blog.rugged, filename).map do |hunk|
      email = hunk.dig(:orig_signature, :email)
      next if email == author.email
      email
    end.compact.uniq

    @contributors ||= Person.where(email: emails)
  end

  def raw_content
    frontmatter + "\n" + content
  end

  def frontmatter
    "---\n" + %w[title slug excerpt tags status published_at].map do |attribute|
      "#{attribute}: #{send(attribute)}"
    end.join("\n") + "\n---"
  end

  def attributes
    {
      id: nil,
      title: nil,
      slug: nil,
      filename: nil,
      excerpt: nil,
      content: nil,
      tags: [],
      status: nil,
      published_at: nil,
      author_nickname: nil
    }
  end

  alias to_hash serializable_hash

  def persisted?
    id.present?
  end

  def non_unique?
    self.class.all.any? { |post| post.filename === filename && post.id != id }
  end

  def elasticsearch_repo
    PostRepository.new
  end
end
