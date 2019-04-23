# frozen_string_literal: true

module GitRepo
  extend ActiveSupport::Concern

  included do
    before_create :create_repository
    before_save :rename_repository, if: -> { !new_record? && slug_changed? }
    before_destroy :destroy_repository
  end

  def repo_name
    "#{author.nickname}/#{slug}.git".freeze
  end

  def repo
    Git::Repository.new(name: repo_name)
  end

  private

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
