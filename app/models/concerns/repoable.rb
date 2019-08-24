# typed: ignore
# frozen_string_literal: true

module Repoable
  extend ActiveSupport::Concern

  included do
    validates :repo_name, :repo_full_name, :repo_path, presence: true
    validates_db_uniqueness_of :repo_name, scope: :slug
    validates_db_uniqueness_of :repo_full_name
    validates_db_uniqueness_of :repo_path

    before_validation :assign_default_attributes, on: :create
    after_create -> { repository.create }
    after_update -> { repository.rename(path: repo_path_was, new_path: repo_path) }, if: :repo_path_changed?

    after_destroy -> { repository.destroy }
    after_rollback -> { repository.destroy }, on: :create
  end

  def repository
    @repository ||= Repository.new(name: repo_name, full_name: repo_full_name, path: repo_path, author: owner)
  end

  private

  def assign_default_attributes
    self.repo_name ||= Repository::DEFAULT_NAME
    self.repo_full_name = "#{slug}/#{repo_name}"
    self.repo_path = Git.config.storage_path.join("#{repo_full_name}.git")
  end
end
