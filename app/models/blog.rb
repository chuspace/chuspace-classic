# frozen_string_literal: true

class Blog < ApplicationRecord
  include Sluggable
  sluggable source: :name

  validates :name, :slug, presence: true
  validates :slug, uniqueness: { scope: :person_id }

  before_create :create_git_repository
  before_destroy :remove_git_repository

  belongs_to :person
  has_many :posts

  def git_repo_full_path
    Git.config.git_storage_pathname.join(git_repo_path).tap(&:mkpath).to_s
  end

  def git_repo_path
    "#{person.nickname}/#{git_repo_name}".freeze
  end

  def git_repo_name
    "#{slug}.git".freeze
  end

  def git_repo
    Rugged::Repository.discover(git_repo_full_path)
  end

  def self.import(url, credentials = {})
    credentials = Rugged::Credentials::UserPassword.new(
      username: credentials[:username],
      password: credentials[:password]
    )

    Rugged::Repository.clone_at(url, git_repo_full_path, credentials: credentials)
  end

  def repo_exists?(dir_name)
    File.exist?(git_repo_full_path)
  end

  private

  def create_git_repository
    Rugged::Repository.init_at(git_repo_full_path, :bare)
  end

  def remove_git_repository
    Rails.logger.info "Removing repository from <#{git_repo_full_path}>."
    FileUtils.rm_rf(git_repo_full_path)
  end

  def mv_git_repository(name, new_name)
    $logger.info "Moving repository from #{repo_path(name)} to <#{repo_path(new_name)}>."
    FileUtils.mv(repo_path(name), repo_path(new_name))
  end
end
