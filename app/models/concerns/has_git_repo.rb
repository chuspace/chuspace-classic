# frozen_string_literal: true

module HasGitRepo
  extend ActiveSupport::Concern

  included do
    validates :repo_name, :repo_name, presence: true, uniqueness: true

    before_validation on: :create do
      self.repo_name = "#{nickname}.git"
      self.repo_path = Git.config.storage_path.join(repo_name)
    end

    before_create -> { repo.create(author: self) }

    before_save if: -> { !new_record? && repo_path_changed? } do
      repo.rename(repo_path_was, repo_path)
    end

    after_destroy :destroy_repository, -> { repo.destroy }
  end

  def repository
    Git::Repository.new(path: repo_path)
  end
  alias repo repository
end
