# frozen_string_literal: true

class Post
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks
  include ActiveModel::Serialization
  include ActiveModel::Dirty

  STATUSES       = %w[draft published archieved]
  DEFAULT_STATUS = 'draft'

  attr_reader   :errors
  attr_accessor :id, :title, :slug, :excerpt, :content, :tags,
                :status, :published_at, :author_email,
                :contributors_email, :new_record

  before_validation     :assign_slug
  validates_presence_of :title, :slug, :status, :author
  validate :check_uniqueness

  delegate :blog, to: :author

  def initialize(attributes = {})
    @new_record = false

    super
    @errors = ActiveModel::Errors.new(self)
  end

  class << self
    delegate :first, :last, to: :all

    def new_from_es(hash)
      post = new(hash)
      post
    end

    def initialize_from_blob(blob)
      raw_content                = blob.content
      frontmatter                = YAML.load(raw_content)
      post                       = new(frontmatter)

      post.id                    = blob.id
      post.content               = raw_content.gsub(/---(.|\n)*---/, '').strip!
      post.author_email          = blob.author_email
      post.contributors_email    = blob.contributors_email
      post
    end

    def initialize_from_blob!(raw_content)
      initialize_from_blob(raw_content).validate!
    end

    def all
      Person.all.flat_map do |person|
        person.all_posts
      end
    end

    def exists?(slug:)
      all.any? { |post| post.slug.strip === slug.downcase.strip }
    end
  end

  def save(commit_message: "#{author.name} commited #{Time.now}", action: :add)
    blog.create_commit(
      commit: {
        message: commit_message,
        branch: 'master'
      },
      file: {
        content: raw_content,
        path: "#{slug}.md"
      }
    )
  end

  def author
    @author ||= Person.find_by(email: author_email) if author_email.present?
  end

  def contributors
    @contributors ||= Person.find_by(email: contributors_email) if contributors_email.any?
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
      excerpt: nil,
      content: nil,
      tags: [],
      status: nil,
      published_at: nil,
      author_email: nil,
      contributors_email: []
    }
  end

  alias to_hash serializable_hash

  def persisted?
    Post.all.any? { |post| post.slug.strip === slug }
  end

  private

  def assign_slug
    self.slug   = title&.parameterize&.downcase&.strip
    self.status = DEFAULT_STATUS if status.blank?
  end

  def check_uniqueness
    errors.add(:slug, 'already taken') if persisted?
  end
end
