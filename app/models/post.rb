# frozen_string_literal: true

class Post
  class InvalidAuthor < StandardError;  end

  include ActiveModel::Model
  include ActiveModel::AttributeAssignment
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks
  include ActiveModel::Serialization
  include ActiveModel::Dirty

  STATUSES       = %w[draft published archieved]
  DEFAULT_STATUS = 'draft'

  attr_reader   :errors
  attr_accessor :id, :title, :slug, :filename, :excerpt, :content, :tags,
                :status, :published_at, :author_nickname, :commit_sha

  validates_presence_of :title, :slug, :status, :author_nickname

  define_attribute_methods :filename

  def initialize(attributes = {})
    @filename = attributes[:filename]
    @errors   = ActiveModel::Errors.new(self)

    super
  end

  class << self
    delegate :first, :last, to: :all

    def initialize_from_blob(blob)
      frontmatter = YAML.load(blob.content)
      attrs = frontmatter.merge(
        id: blob.id,
        filename: blob.name,
        author_nickname: blob.author_nickname,
        commit_sha: blob.commit_sha,
        content: blob.content.gsub(/---(.|\n)*---/, '')
      )

      post = new(attrs)
      post.slug ||= post.filename
      post
    end

    def all
      Person.all.flat_map do |person|
        person.all_posts
      end
    end

    def find(author:, filename:)
      blob = author.blog.find_blob(filename)
      initialize_from_blob(blob) if blob
    end

    def exists?(filename:)
      all.any? { |post| post.filename === filename }
    end
  end

  def filename=(new_filename)
    filename_will_change! unless @filename == new_filename
    @filename = new_filename
  end

  def raw_content
    frontmatter + "\n" + content
  end

  def frontmatter
    "---\n" + %w[title slug excerpt tags status published_at].map do |attribute|
      "#{attribute}: #{send(attribute)}"
    end.join("\n") + "\n---"
  end

  def persisted?
    id.present?
  end

  def attributes
    {
      id: nil,
      title: nil,
      slug: nil,
      filename: nil,
      excerpt: nil,
      content: nil,
      tags: nil,
      status: nil,
      published_at: nil,
      author_nickname: nil,
      commit_sha: nil
    }
  end
end
