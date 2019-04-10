# frozen_string_literal: true

class Post
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks
  extend ActiveModel::Naming
  include ActiveModel::Serialization
  include ActiveModel::Conversion

  STATUSES       = %w[draft published archieved]
  DEFAULT_STATUS = 'draft'

  attr_reader   :errors
  attr_accessor :id, :title, :slug, :excerpt, :content, :tags, :raw_content,
                :status, :published_at, :frontmatter, :author

  before_validation     :assign_slug
  validates_presence_of :title, :slug, :status

  searchkick

  delegate :blog, to: :author

  def initialize(attributes = {})
    super
    @errors = ActiveModel::Errors.new(self)
  end

  def self.initialize_from_blob(raw_content)
    frontmatter       = YAML.load(raw_content)
    post              = new(frontmatter)
    post.content      = raw_content.gsub(/---(.|\n)*---/, '').strip!
    post.frontmatter  = frontmatter
    post.raw_content  = raw_content
    post
  end

  def self.initialize_from_blob!(raw_content)
    initialize_from_blob(raw_content).validate!
  end

  alias id slug

  def commit_to_blog(commit_message: "#{author.name} commited #{Time.now}")
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

  def self.all
    Person.all.flat_map do |person|
      person.all_posts
    end
  end

  def raw_content
    @raw_content = frontmatter + "\n" + content
  end

  def frontmatter
    @frontmatter = "---\n" + %w[title slug excerpt tags status published_at].map do |attribute|
      "#{attribute}: #{send(attribute)}"
    end.join("\n") + "\n---"
  end

  def attributes
    {
      title: nil,
      slug: nil,
      excerpt: nil,
      content: nil,
      tags: [],
      status: nil,
      published_at: nil,
      author: nil
    }
  end

  private

  def assign_slug
    self.slug   = title&.parameterize&.downcase&.strip
    self.status = DEFAULT_STATUS if status.blank?
  end
end
