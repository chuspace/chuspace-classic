# frozen_string_literal: true

module HasGitRepo
  extend ActiveSupport::Concern

  included do
    before_validation :assign_repo_details
    before_create -> { repo.create(author: author) }
    before_save :rename_repository, if: -> { !new_record? && repo_name_changed? }
    before_destroy -> { repo.destroy }
  end

  def repo
    Git::Repository.new(path: repo_path)
  end

  private

  def assign_repo_details
    self.repo_name = "#{slug}.git"
    self.repo_path = File.join(author.blog_storage_path, repo_name).to_s
  end

  def rename_repository(record)
    repo.rename(new_path: record.repo_path)
  end
end
