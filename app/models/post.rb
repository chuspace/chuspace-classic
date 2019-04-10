class Post
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks
  extend ActiveModel::Naming

  attr_reader   :errors
  attr_accessor :title, :slug, :excerpt, :content, :tags,
                :author_nickname, :status, :published_at

  before_validation     :assign_slug
  validates_presence_of :title, :slug, :author_nickname, :status

  delegate :blog_repo, to: :author

  def initialize(attributes = {})
    super
    @errors = ActiveModel::Errors.new(self)
  end

  def author
    Person.find_by(nickname: author_nickname)
  end

  private

  def assign_slug
    self.slug = title&.parameterize&.downcase&.strip
  end
end
