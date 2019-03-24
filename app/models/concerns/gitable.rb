# frozen_string_literal: true

module Gitable
  extend ActiveSupport::Concern

  included do
    GIT_REPO_NAME = 'blog.git'

    before_create :create_git_repository
    before_destroy :remove_git_repository
    before_save :mv_git_repository, if: -> { !new_record? && nickname_changed? }
  end

  class_methods do
    def repo_path_for(nickname:)
      full_name = "#{nickname}/#{GIT_REPO_NAME}"
      Git.config.git_storage_pathname.join(full_name).tap(&:mkpath).to_s
    end
  end

  def git_repo
    Rugged::Repository.new(git_repo_full_path)
  end

  def git_storage_path
    self.class.repo_path_for(nickname: nickname)
  end

  def git_repo_full_path
    Git.config.git_storage_pathname.join(git_repo_full_name).tap(&:mkpath).to_s
  end

  def git_repo_full_name
    "#{nickname}/#{git_repo_name}".freeze
  end

  def git_repo_name
    GIT_REPO_NAME
  end

  def repo_exists?
    File.exist?(git_repo_full_path)
  end

  private

  def create_git_repository
    Rugged::Repository.init_at(git_repo_full_path, :bare)
  end

  def remove_git_repository
    Rails.logger.info "Removing repository for <#{name}> from <#{git_storage_path}>."
    FileUtils.rm_rf(git_storage_path)
  end

  def mv_git_repository
    from = self.class.repo_path_for(nickname: nickname_was)
    to   = self.class.repo_path_for(nickname: nickname)
    Rails.logger.info "Moving repository from #{from} to <#{to}>."
    FileUtils.mv(from, to)
  end
end
