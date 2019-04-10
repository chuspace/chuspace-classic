# frozen_string_literal: true

class Post
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks
  extend ActiveModel::Naming

  DEFAULT_STATUS = 'draft'

  attr_reader   :errors
  attr_accessor :title, :slug, :excerpt, :content, :tags,
                :status, :published_at

  before_validation     :assign_slug
  validates_presence_of :title, :slug, :status

  delegate :blog, to: :author

  def initialize(attributes = {})
    super
    @errors = ActiveModel::Errors.new(self)
  end

  def self.initialize_from_markdown(markdown)
    frontmatter = YAML.load(markdown)
    content     = markdown.gsub(/---(.|\n)*---/, '').strip!

    new(frontmatter.merge(content: content))
  end

  def self.initialize_from_markdown!(markdown)
    initialize_from_markdown(markdown).validate!
  end

  def author
    Person.find_by(nickname: author_nickname)
  end

  private

  def assign_slug
    self.slug   = title&.parameterize&.downcase&.strip
    self.status = DEFAULT_STATUS if status.blank?
  end
end
