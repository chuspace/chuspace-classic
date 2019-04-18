# frozen_string_literal: true

class Blog < ApplicationRecord
  belongs_to :author, class_name: 'User'

  enum visibility: { public: 0, private: 1, premium: 2 }

  before_create :create_repository
  before_save :rename_repository, if: -> { !new_record? && slug_changed? }
  before_destroy :destroy_repository

  def to_param
    slug
  end

  def repo
    Git::Repository.new(blog: self)
  end

  private

  def create_repository
    repo.create
  end

  def rename_repository(record)
    new_path = Git::Repository.new(blog: record).path
    repo.rename(new_path)
  end

  def destroy_repository
    repo.destroy
  end
end
