# typed: ignore
# frozen_string_literal: true

require 'mimemagic'

class Blob
  include ::EncodingHelper, ActiveModel::AttributeMethods, ActiveModel::Model
  extend ActiveModel::Callbacks

  MAX_IMAGE_SIZE = 15.megabytes
  MAX_POST_SIZE = 1.megabytes
  EXTENSIONS = %w[.jpg .png .jpeg .gif .md]
  SAFELISTED = %w[.gitignore .keep]

  attr_accessor :path, :repository, :commit_sha
  attr_reader :name, :extname, :object

  validates :name, :path, :repository, presence: true
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
        next unless valid?(name)

        path = root.blank? ? name : File.join(root, name)
        blobs << find(repository: repository, path: path, commit_sha: commit_sha)
      end

      blobs
    end

    def find(repository:, path:, commit_sha: nil)
      blob = new(repository: repository, path: path, commit_sha: commit_sha)
      blob.persisted? ? blob : nil
    end

    def valid?(name)
      mime = MimeMagic.by_path(name)
      extname = File.extname(name).downcase
      (mime&.image? || mime&.text?) && EXTENSIONS.include?(extname)
    end
  end

  def initialize(attributes = {})
    super

    @path ||= ''
    @name = File.basename(path || '', '.*')
    @extname = File.extname(path || '').downcase
    @commit_sha ||= repository.commit_sha
  end

  def to_param
    name
  end

  def object
    @object ||= repository.rugged.blob_at(commit_sha, path)
  end

  def summary
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

  def post
    @post ||= author.posts.find_by(blob_path: path)
  end

  def outdated?
    post&.blob_id != oid
  end

  def published?
    post&.published?
  end

  def post?
    mime.text? && extname == '.md'
  end

  def save(io:, commit_message: nil)
    if valid? && Rugged::Repository.hash_data(io, :blob) != oid
      commit_message ||= persisted? ? "Updated #{path}" : "Added #{path}"
      repository.create_commit(content: io, message: commit_message, path: path)
      reload
    end

    self
  end

  def mime
    MimeMagic.by_path(path)
  end

  private

  def sync
    S3Service.upload(io: io, filename: path, bucket: repository.author.nickname)
  end

  def should_have_correct_content_type
    errors.add(:content, :invalid_content_type) unless mime.image? || mime&.text?
  end

  def should_have_correct_content_size
    case mime.mediatype
    when :image
      errors.add(:content, :invalid_size) if size > MAX_IMAGE_SIZE
    when :text
      errors.add(:content, :invalid_size) if size > MAX_POST_SIZE
    end
  end

  def should_have_correct_extname
    errors.add(:name, :invalid_extname) unless EXTENSIONS.include?(extname)
  end

  def reload
    @object = nil
  end
end
