# typed: ignore
# frozen_string_literal: true

module Repoable
  extend ActiveSupport::Concern

  included do
    validates :repo_name, :repo_path, presence: true
    validates_db_uniqueness_of :repo_name
    validates_db_uniqueness_of :repo_path

    before_validation :assign_default_attributes
    after_create -> { repository.create }
    before_update :rename, if: :repo_path_changed?

    after_commit -> { @repository = nil }
    after_destroy -> { repository.destroy }
    after_rollback -> { repository.destroy }, on: :create
  end

  def repository
    @repository ||= Repository.new(name: repo_name, path: repo_path, author: owner)
  end

  private

  def rename
    repository.rename(path: repo_path_was, new_path: repo_path)
  end

  def assign_default_attributes
    self.repo_name = "#{slug}.git"
    self.repo_path = Git.config.storage_path.join(repo_name)
  end
end
