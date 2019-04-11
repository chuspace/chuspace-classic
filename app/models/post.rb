# frozen_string_literal: true

class Post
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks

  STATUSES       = %w[draft published archieved]
  DEFAULT_STATUS = 'draft'

  attr_reader   :errors
  attr_accessor :id, :title, :slug, :excerpt, :content, :tags, :raw_content,
                :status, :published_at, :frontmatter, :author, :contributors

  before_validation     :assign_slug
  validates_presence_of :title, :slug, :status, :author

  delegate :blog, to: :author

  def initialize(attributes = {})
    super
    @errors = ActiveModel::Errors.new(self)
  end

  def self.initialize_from_blob(blob)
    raw_content       = blob.content
    frontmatter       = YAML.load(raw_content)
    post              = new(frontmatter)

    post.id           = blob.id
    post.content      = raw_content.gsub(/---(.|\n)*---/, '').strip!
    post.frontmatter  = frontmatter
    post.raw_content  = raw_content
    post.author       = Person.find_by(email: blob.author_email)
    post.contributors = Person.find_by(email: blob.contributors)
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

  private

  def assign_slug
    self.slug   = title&.parameterize&.downcase&.strip
    self.status = DEFAULT_STATUS if status.blank?
  end
end
