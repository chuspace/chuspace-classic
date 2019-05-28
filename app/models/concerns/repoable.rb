# frozen_string_literal: true

module Repoable
  extend ActiveSupport::Concern

  included do
    validates :repo_path, presence: true, uniqueness: true

    before_validation :assign_repo_path, on: :create
    before_create -> { repo.create(author: self) }
    before_save :rename_repository, if: -> { !new_record? && nickname_changed? }
    after_destroy :destroy_repository
  end

  def repo
    Git::Repository.new(path: repo_path)
  end

  def repo_name
    "#{nickname}.git"
  end

  private

  def assign_repo_path
    self.repo_path = Git.config.storage_path.join(repo_name)
  end

  def rename_repository
    repo.create(old_path, new_path)
  end

  def destroy_repository
    repo.destroy
  end
end
