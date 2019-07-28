# typed: false
# frozen_string_literal: true

class Edition < ApplicationRecord
  include AASM

  db_belongs_to :editor, class_name: 'User', foreign_key: 'editor_id'
  db_belongs_to :post

  enum status: { opened: 0, merged: 1, closed: 2 }

  validates_db_uniqueness_of :branch_name
  validates_presence_of :status
  validate :must_be_for_published_post

  delegate :repository, to: :post
  delegate :content, to: :blob, prefix: true

  after_destroy :delete_branch

  aasm column: :status, enum: true do
    state :opened, initial: true
    state :merged, :closed

    event :merge do
      transitions from: :opened, to: :merged
    end

    event :close do
      transitions from: :opened, to: :merged
    end

    event :open do
      transitions from: :closed, to: :opened
    end
  end

  def commit_sha
    branch.target_id
  end

  def commit
    branch.target
  end

  def blob
    @blob ||= repository.blob_at(path: post.blob_path, sha: branch.target_id)
  end

  def branch
    @branch ||= repository.find_branch(name: branch_name)
  end

  private

  def must_be_for_published_post
    errors.add(:post, :no_edition_possible) unless post.published?
  end

  def delete_branch
    repository.branches.delete(branch_name)
  end
end
