# typed: false
# frozen_string_literal: true

class Edition < ApplicationRecord
  include AASM

  db_belongs_to :editor, class_name: 'User', foreign_key: 'editor_id'
  db_belongs_to :post

  enum status: { draft: 0, open: 1, merged: 2, closed: 3 }

  validates_db_uniqueness_of :branch_name
  validates_presence_of :status
  validate :must_be_for_published_post

  delegate :repository, to: :post
  delegate :content, to: :blob, prefix: true

  after_destroy :delete_branch

  aasm column: :status, enum: true do
    state :draft, initial: true
    state :open, :merged, :closed

    event :open do
      transitions from: :draft, to: :open
      transitions from: :closed, to: :open
    end

    event :merge do
      transitions from: :open, to: :merged
    end

    event :close do
      transitions from: :open, to: :closed
      transitions from: :open, to: :draft
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

  def mergeable?
    repository.merge_index(commit).present?
  end

  private

  def must_be_for_published_post
    errors.add(:post, :no_edition_possible) unless post.published?
  end

  def delete_branch
    repository.branches.delete(branch_name)
  end
end
