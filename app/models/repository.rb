# frozen_string_literal: true

class Repository < ApplicationRecord
  class NoRepository < StandardError; end
  class InvalidRef < StandardError; end

  DEFAULT_NAME = 'blog.git'
  START_REF = 'HEAD'
  DEFAULT_REF = 'refs/heads/master'
  CONTRIBUTIONS_REF = 'refs/heads/contributions'
  GLOBAL_HOOKS_DIRECTORY = Rails.root.join('bin', 'git-hooks')
  GITIGNORE_PATH = '.gitignore'
  GITIGNORE = <<~STRING
    # Ignore everything
    *

    # Except
    !.gitignore
    !*.md
    !*.png
    !*.gif
    !*.jpeg

    # Allow sub-directories
    !/*
  STRING

  validates :name, :path, presence: true, uniqueness: true

  before_validation :assign_default_attributes, on: :create
  before_create :create_git_repo, :create_git_hooks, :create_initial_commit_and_assign_commit_sha
  before_save :rename_git_repo, if: -> { !new_record? && path_changed? }
  after_destroy :destroy_git_repo
  after_rollback :destroy_git_repo, on: :create

  belongs_to :author, class_name: 'User'
  has_many :posts, dependent: :destroy
  delegate :lookup, :checkout, :empty?, :bare?, :index, to: :rugged

  def commit
    lookup(commit_sha)
  end

  def rugged
    @rugged ||= Rugged::Repository.bare(path)
  rescue Rugged::RepositoryError, Rugged::OSError
    fail NoRepository, 'no repository for such path'
  end

  def exists?
    !!rugged
  rescue NoRepository
    false
  end

  def size
    size = popen(%w[du -sk], path).first.strip.to_i
    (size.to_f / 1_024).round(2)
  end

  def author_hash
    {
      name: author.name,
      email: author.email,
      nickname: author.nickname
    }.freeze
  end

  def blobs(ref = DEFAULT_REF)
    return [] if empty?

    sha = sha_from_ref(ref)

    Git::Blob.all(self, sha)
  end

  def find_blob(id, ref = DEFAULT_REF)
    Git::Blob.find(self, id, ref)
  end

  def find_commit(sha)
    Git::Commit.find(self, sha)
  end

  def sha_from_ref(ref)
    rev_parse_target(ref).oid
  rescue Rugged::ReferenceError
    nil
  end

  def rev_parse_target(revspec)
    obj = rugged.rev_parse(revspec)
    Git::Branch.dereference_object(obj)
  end

  def merge_base_commit(from, to)
    rugged.merge_base(from, to)
  end

  private

  def assign_default_attributes
    self.name = "#{author.nickname}/#{DEFAULT_NAME}"
    self.path = Git.config.storage_path.join(name)
  end

  def create_git_repo
    Git.logger.info "Creating repository for <#{name}> from <#{path}>."
    FileUtils.mkdir_p(path, mode: 0o770)

    repo = Rugged::Repository.init_at(path, :bare)
    repo.config['user.name'] = author.name
    repo.config['user.email'] = author.email
    repo.config['user.nickname'] = author.nickname
    repo.close
  end

  def create_git_hooks
    local_hooks_directory = File.join(path, 'hooks')
    real_local_hooks_directory = :not_found

    begin
      real_local_hooks_directory = File.realpath(local_hooks_directory)
    rescue Errno::ENOENT
      # real_local_hooks_directory == :not_found
    end

    if real_local_hooks_directory != File.realpath(GLOBAL_HOOKS_DIRECTORY)
      if File.exist?(local_hooks_directory)
        Git.logger.info "Moving existing hooks directory and symlinking global hooks directory for #{path}."
        FileUtils.mv(local_hooks_directory, "#{local_hooks_directory}.old.#{Time.now.to_i}")
      end

      FileUtils.ln_sf(GLOBAL_HOOKS_DIRECTORY, local_hooks_directory)
    else
      Git.logger.info "Hooks already exist for #{path}."
    end
  end

  def create_initial_commit_and_assign_commit_sha
    self.commit_sha = Git::Commit.create(
      repository: self,
      committer: author,
      options: {
        commit: { message: 'Initial commit' }, file: { content: GITIGNORE, path: GITIGNORE_PATH }
      }
    )
  end

  def destroy_git_repo
    Git.logger.info "Removing repository for <#{name}> from <#{path}>."
    FileUtils.rm_rf(path)
  end

  def rename_git_repo
    Git.logger.info "Moving repository from #{path_was} to <#{path}>."
    FileUtils.mv(path_was, path)
  end
end
