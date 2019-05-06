# frozen_string_literal: true

module GitRepo
  extend ActiveSupport::Concern

  included do
    before_validation :assign_repo_details
    before_create :create_repository
    before_save :rename_repository, if: -> { !new_record? && repo_name_changed? }
    before_destroy :destroy_repository
  end

  def repo
    Git::Repository.new(path: repo_path)
  end

  private

  def assign_repo_details
    self.name_with_author = "#{author.nickname}/#{slug}"
    self.repo_name = "#{name_with_author}.git"
    self.repo_path = Git.config.repositories_path.join(repo_name).to_s
  end

  def create_repository
    repo.create(author: author)
  end

  def rename_repository(record)
    repo.rename(new_name: record.repo_name)
  end

  def destroy_repository
    repo.destroy
  end
end
