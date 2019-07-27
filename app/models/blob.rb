# typed: ignore
# frozen_string_literal: true

class Blob
  include ::EncodingHelper, ActiveModel::AttributeMethods, ActiveModel::Model
  extend ActiveModel::Callbacks

  MAX_IMAGE_SIZE = 15.megabytes
  MAX_POST_SIZE = 1.megabytes
  EXTENSIONS = %w[.jpg .png .jpeg .gif .md]
  SAFELISTED = %w[.gitignore .keep]

  attr_accessor :path, :repository, :content, :commit_sha
  attr_reader :name, :extname, :object

  validates :name, :path, :repository, :content, presence: true
  validates :name, format: { with: /\A^[a-zA-Z0-9_-]*$\z/i }
  validates_length_of :name, maximum: 100
  validate :should_have_correct_content_type
  validate :should_have_correct_content_size
  validate :should_have_correct_extname, unless: -> { SAFELISTED.include?(name) }

  define_model_callbacks :create, only: :after
  define_model_callbacks :update, only: :after

  after_create :sync
  after_update :sync

  delegate :oid, :binary?, :size, to: :object, allow_nil: true
  delegate :author, to: :repository

  class << self
    def all(repository:, commit_sha: nil)
      blobs = []
      tree = commit_sha ? repository.lookup(commit_sha).tree : repository.tree

      tree.walk_blobs(:postorder) do |root, blob_entry|
        name = blob_entry[:name]

        path = root.blank? ? name : File.join(root, name)
        blobs << find(repository: repository, path: path, commit_sha: commit_sha)
      end

      blobs
    end

    def find(repository:, path:, commit_sha: nil)
      blob = new(repository: repository, path: path, commit_sha: commit_sha)
      blob.persisted? ? blob : nil
    end

    def create(repository:, path:, content:, commit_message: nil)
      Blob.new(repository: repository, path: path).save(io: content, commit_message: commit_message)
    end

    def valid?(name)
      extname = File.extname(name).downcase
      EXTENSIONS.include?(extname)
    end
  end

  def initialize(attributes = {})
    super

    @name = File.basename(path || '', '.*')
    @extname = File.extname(path || '').downcase
    @commit_sha ||= repository.commit_sha
  end

  def to_param
    name
  end

  def object
    @object ||= path && commit_sha ? repository.rugged.blob_at(commit_sha, path) : nil
  end

  def content
    @content ||= encode!(object&.content || '')
  end

  def io
    binary? ? content : StringIO.new(content)
  end

  def empty?
    !content || content == ''
  end

  def persisted?
    !!oid
  end

  def save(io:, commit_message: nil)
    @content = encode!(io)

    if valid? && Rugged::Repository.hash_data(io, :blob) != oid
      commit_message ||= persisted? ? "Updated #{path}" : "Added #{path}"
      @commit_sha = repository.create_commit(content: content, message: commit_message, path: path)
      @object = nil
    end

    self
  end

  def destroy(commit_message: nil)
    if persisted?
      @commit_sha = repository.create_commit(path: path, message: commit_message, content: nil, action: :remove)
      @object = nil
      true
    else
      false
    end
  end

  def mime
    MiniMime.lookup_by_filename(path)
  end

  def post?
    mime&.content_type == 'text/markdown' && mime&.extension == 'md'
  end

  def image?
    mime&.content_type&.include?('image')
  end

  private

  def sync
    S3Service.upload(io: io, filename: path, bucket: repository.author.nickname)
  end

  def should_have_correct_content_type
    errors.add(:content, :invalid_content_type) unless image? || post?
  end

  def should_have_correct_content_size
    size = content.bytesize

    if image?
      errors.add(:content, :invalid_size, size: MAX_IMAGE_SIZE, type: 'an image') if size > MAX_IMAGE_SIZE
    elsif post?
      errors.add(:content, :invalid_size, size: MAX_POST_SIZE, type: 'a post') if size > MAX_POST_SIZE
    end
  end

  def should_have_correct_extname
    errors.add(:name, :invalid_extname) unless EXTENSIONS.include?(extname)
  end
end
