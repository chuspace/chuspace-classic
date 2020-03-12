# typed: true
# frozen_string_literal: true

class Blob
  include ::EncodingHelper, ActiveModel::AttributeMethods, ActiveModel::Model
  extend ActiveModel::Callbacks

  MAX_IMAGE_SIZE = 15.megabytes
  MAX_POST_SIZE = 1.megabytes
  EXTENSIONS = %w[.jpg .png .jpeg .gif .md]
  SAFELISTED = %w[.gitignore .keep]

  attr_accessor :path, :repository, :content, :commit_sha
  attr_reader :name, :extname, :object, :absolute_path

  validates :name, :path, :repository, presence: true
  validates :content, presence: true, unless: :safelisted
  validates :name, format: { with: /\A^[a-zA-Z0-9_-]*$\z/i }, unless: :safelisted
  validates_length_of :name, maximum: 100, unless: :safelisted
  validate :should_have_correct_content_type, unless: :safelisted
  validate :should_have_correct_content_size, unless: :safelisted
  validate :should_have_correct_extname, unless: :safelisted

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

    def create(repository:, path:, content:, branch:, committer: nil, commit_message: nil)
      Blob.new(repository: repository, path: path).save(
        io: content, committer: committer, commit_message: commit_message, branch: branch
      )
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
    @absolute_path = File.join('/', path)
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
    StringIO.new(content)
  end

  def empty?
    !content || content == ''
  end

  def persisted?
    !!oid
  end

  def save(committer:, io:, branch: Repository::DEFAULT_BRANCH, commit_message: nil)
    @content = encode!(io)

    if valid? && Rugged::Repository.hash_data(content, :blob) != oid
      commit_message ||= persisted? ? "Updated post #{path}" : "Created post #{path}"
      options = {
        commit: { message: commit_message, branch: branch, committer: committer },
        file: { content: content, path: path }
      }
      @commit_sha = repository.create_commit(options: options)
      @object = nil
    end

    self
  end

  def rename(committer:, new_path:, branch: Repository::DEFAULT_BRANCH, commit_message: nil)
    commit_message ||= "Moved from #{path} to #{new_path}"
    options = {
      commit: { message: commit_message, branch: branch, committer: committer },
      file: { content: content, previous_path: path, path: new_path }
    }
    @commit_sha = repository.create_commit(options: options, action: :rename)

    @path = new_path
    @object = nil

    self
  end

  def destroy(committer:, branch: Repository::DEFAULT_BRANCH, commit_message: nil)
    if persisted?
      commit_message ||= "Deleted #{path}"
      options = {
        commit: { message: commit_message, branch: branch, committer: committer },
        file: { content: content, path: path }
      }
      @commit_sha = repository.create_commit(options: options, action: :remove)
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
    mime&.content_type == 'text/markdown' && mime&.extension == 'md' && Repository.in_post_path?(path)
  end

  def image?
    mime&.content_type&.include?('image') && Repository.in_image_path?(path)
  end

  private

  def should_have_correct_content_type
    errors.add(:content, :invalid_content_type) unless image? || post?
  end

  def safelisted
    SAFELISTED.include?(name)
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
