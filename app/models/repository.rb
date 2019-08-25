# typed: false
# frozen_string_literal: true

class Repository
  extend T::Sig
  include Commitable, ActiveModel::AttributeMethods, ActiveModel::Model

  class NoRepository < StandardError; end
  class InvalidRef < StandardError; end

  DEFAULT_NAME = 'blog'
  START_REF = 'HEAD'
  DEFAULT_BRANCH = 'master'
  GLOBAL_HOOKS_DIRECTORY = Rails.root.join('bin', 'git-hooks')
  GITIGNORE_PATH = '.gitignore'
  IMAGES_ROOT_PATH = 'images'
  DRAFTS_ROOT_PATH = 'drafts'
  POSTS_ROOT_PATH = 'posts'

  GITIGNORE = <<~STRING
    # Ignore everything
    *
    # Allow
    !.gitignore
    !/posts
    !/posts/*.md
    !/posts/.keep
    !/drafts
    !/drafts/*.md
    !/drafts/.keep
    !/images
    !/images/.keep
    !/images/*.png
    !/images/*.gif
    !/images/*.jpeg
    !/images/*.jpg
  STRING

  attr_accessor :name, :path, :full_name, :author
  validates :name, :full_name, :path, :author, presence: true

  delegate :lookup, :checkout, :empty?, :bare?, :index, :branches, to: :rugged
  delegate :tree, to: :commit

  sig { params(path: String).returns(T::Boolean) }
  def self.in_post_path?(path)
    path.start_with?(DRAFTS_ROOT_PATH, POSTS_ROOT_PATH)
  end

  sig { params(path: String).returns(T::Boolean) }
  def self.in_image_path?(path)
    path.start_with?(IMAGES_ROOT_PATH)
  end

  sig { returns(T::nilable(Rugged::Repository)) }
  def rugged
    @rugged ||= Rugged::Repository.bare(path)
  rescue Rugged::RepositoryError, Rugged::OSError, TypeError
    nil
  end

  sig { returns(T::Boolean) }
  def persisted?
    !!rugged
  end

  alias present? persisted?

  sig { returns(T::Boolean) }
  def blank?
    !persisted?
  end

  sig { returns(T::nilable(Rugged::Reference)) }
  def head
    rugged.head
  rescue Rugged::ReferenceError
    nil
  end

  sig { returns(T.nilable(String)) }
  def commit_sha
    head&.target&.oid
  end

  sig { params(sha: T::nilable(String)).returns(Rugged::Commit) }
  def commit(sha: commit_sha)
    lookup(sha)
  end

  sig { params(sha: T::nilable(String)).returns(T::Array[Blob]) }
  def blobs(sha: commit_sha)
    Blob.all(repository: self, commit_sha: sha)
  end

  sig { params(path: String, sha: T::nilable(String)).returns(T.nilable(Blob)) }
  def blob_at(path:, sha: commit_sha)
    Blob.find(repository: self, path: path, commit_sha: sha)
  end

  sig { params(path: String, content: String, commit_message: T::nilable(String), branch: String).returns(Blob) }
  def create_blob(path:, content:, commit_message: nil, branch: DEFAULT_BRANCH)
    Blob.create(repository: self, path: path, content: content, commit_message: commit_message, branch: branch)
  end

  sig { params(name: String).returns(Rugged::Branch) }
  def find_branch(name:)
    branches.find { |branch| branch.name == name }
  end

  sig { returns(String) }
  def ssh_path
    "git@chuspace.com:#{full_name}.git"
  end

  def size
    size = IO.popen(%w[du -sk], path).first.strip.to_i
    (size.to_f / 1_024).round(2)
  end

  def commit_hash(user: author)
    { name: user.name, email: user.email, nickname: user.nickname, time: Time.now }.freeze
  end

  def merge_base_commit(from, to)
    rugged.merge_base(from, to)
  end

  def create_commit(options:, action: :add)
    sha = Git::Commit.create(repository: self, action: action, options: options)
    Rails.logger.info("Committed <#{sha}> to <#{name}>")
    sha
  end

  sig { returns(Repository) }
  def create
    unless persisted?
      Rails.logger.info "Creating repository <#{name}> at <#{path}>."
      FileUtils.mkdir_p(path, mode: 0o770)

      repo = Rugged::Repository.init_at(path, :bare)
      repo.config['user.name'] = author.name
      repo.config['user.email'] = author.email
      repo.config['user.nickname'] = author.nickname
      repo.close

      Rails.logger.info "Created repository <#{name}> at <#{path}>."

      create_git_hooks
      create_defaults

      self
    else
      self
    end
  end

  def destroy
    Rails.logger.info "Removing repository <#{name}> from <#{path}>."
    FileUtils.rm_rf(path)
    @rugged = nil
  end

  def rename(path:, new_path:)
    Rails.logger.info "Moving repository from #{path} to <#{new_path}>."
    FileUtils.mv(path, new_path)
    @path = new_path
    @rugged = nil
  end

  private

  def create_git_hooks
    local_hooks_directory = File.join(path, 'hooks')
    real_local_hooks_directory = :not_found

    begin
      real_local_hooks_directory = File.realpath(local_hooks_directory)
    rescue Errno::ENOENT
      # real_local_hooks_directory == :not_found
    end

    if real_local_hooks_directory != File.realpath(Repository::GLOBAL_HOOKS_DIRECTORY)
      if File.exist?(local_hooks_directory)
        Rails.logger.info "Moving existing hooks directory and symlinking global hooks directory in #{path}."
        FileUtils.mv(local_hooks_directory, "#{local_hooks_directory}.old.#{Time.now.to_i}")
      end

      FileUtils.ln_sf(Repository::GLOBAL_HOOKS_DIRECTORY, local_hooks_directory)
    else
      Rails.logger.info "Hooks already exist at #{path}."
    end
  end

  def create_defaults
    Rails.logger.info "Creating repository defaults <#{name}> at <#{path}>."

    create_blob(path: Repository::GITIGNORE_PATH, content: Repository::GITIGNORE, commit_message: 'Add gitignore')

    drafts_path = File.join(Repository::DRAFTS_ROOT_PATH, '.keep')
    create_blob(path: drafts_path, content: '', commit_message: 'Add drafts folder')

    posts_path = File.join(Repository::POSTS_ROOT_PATH, '.keep')
    create_blob(path: posts_path, content: '', commit_message: 'Add posts folder')

    images_path = File.join(Repository::IMAGES_ROOT_PATH, '.keep')
    create_blob(path: images_path, content: '', commit_message: 'Add images folder')

    Rails.logger.info "Created repository defaults <#{name}> at <#{path}>."
  end
end
