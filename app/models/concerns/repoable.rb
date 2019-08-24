# typed: ignore
# frozen_string_literal: true

module Repoable
  extend ActiveSupport::Concern

  included do
    before_create :create_git_repo, :create_git_hooks, :add_gitignore, :add_drafts_folder, :add_posts_folder, :add_images_folder
    before_update :rename_git_repo, if: -> { send("#{self.class.repo_name_attribute}_changed?") }
    before_destroy :destroy_git_repo

    after_rollback :destroy_git_repo, on: :create
  end

  class_methods do
    attr_reader :repo_name_attribute, :author_attribute

    def has_one_repo(repo_name, author)
      @repo_name_attribute = repo_name
      @author_attribute = author
    end
  end

  def repo_name
    send(self.class.repo_name_attribute)
  end

  def full_repo_name
    "#{repo_name}.git"
  end

  def author
    send(self.class.author_attribute)
  end

  def repo_path
    Git.config.storage_path.join(full_repo_name)
  end

  def repository
    @repository ||= Repository.new(name: repo_name, author: author)
  end

  private

  def create_git_repo
    Rails.logger.info "Creating repository <#{repo_name}> at <#{repo_path}>."
    FileUtils.mkdir_p(repo_path, mode: 0o770)

    author = case self
             when User then self
             when Publication then owner
    end

    repo = Rugged::Repository.init_at(repo_path, :bare)
    repo.config['user.name'] = author.name
    repo.config['user.email'] = author.email
    repo.config['user.nickname'] = author.nickname
    repo.close

    @repository = nil
  end

  def create_git_hooks
    local_hooks_directory = File.join(repo_path, 'hooks')
    real_local_hooks_directory = :not_found

    begin
      real_local_hooks_directory = File.realpath(local_hooks_directory)
    rescue Errno::ENOENT
      # real_local_hooks_directory == :not_found
    end

    if real_local_hooks_directory != File.realpath(Repository::GLOBAL_HOOKS_DIRECTORY)
      if File.exist?(local_hooks_directory)
        Rails.logger.info "Moving existing hooks directory and symlinking global hooks directory in #{repo_path}."
        FileUtils.mv(local_hooks_directory, "#{local_hooks_directory}.old.#{Time.now.to_i}")
      end

      FileUtils.ln_sf(Repository::GLOBAL_HOOKS_DIRECTORY, local_hooks_directory)
    else
      Rails.logger.info "Hooks already exist at #{repo_path}."
    end
  end

  def add_gitignore
    gitignore = <<~STRING
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

    repository.create_blob(path: Repository::GITIGNORE_PATH, content: gitignore, commit_message: 'Add gitignore')
  end

  def add_drafts_folder
    path = File.join(Repository::DRAFTS_ROOT_PATH, '.keep')
    repository.create_blob(path: path, content: '', commit_message: 'Add drafts folder')
  end

  def add_posts_folder
    path = File.join(Repository::POSTS_ROOT_PATH, '.keep')
    repository.create_blob(path: path, content: '', commit_message: 'Add posts folder')
  end

  def add_images_folder
    path = File.join(Repository::IMAGES_ROOT_PATH, '.keep')
    repository.create_blob(path: path, content: '', commit_message: 'Add images folder')
  end

  def destroy_git_repo
    Rails.logger.info "Removing repository <#{repo_name}> from <#{repo_path}>."
    FileUtils.rm_rf(repo_path)
  end

  def rename_git_repo
    old_name = send("#{self.class.repo_name_attribute}_before_last_save")
    old_path = Git.config.storage_path.join("#{old_name}.git")
    Rails.logger.info "Moving repository from #{old_path} to <#{repo_path}>."
    FileUtils.mv(old_path, repo_path)
  end
end
