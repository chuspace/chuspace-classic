# frozen_string_literal: true

class Blob < ApplicationRecord
  include BlobUploader::Attachment.new(:blob)

  belongs_to :repository

  validates :blob_data, presence: true
  validates :path, presence: true, uniqueness: { scope: :repository_id }

  has_one :post, -> { where(blob_type: :text) }, dependent: :destroy, autosave: true

  before_create :add_to_repository
  after_destroy :remove_from_repository
  before_save :sync_with_repository, if: -> { !new_record? && blob_data_changed? }

  attr_accessor :commit_message

  private

  def add_to_repository
    commit(message: commit_message || "Created #{path}")
  end

  def sync_with_repository
    commit(message: commit_message || "Updated #{path}")
  end

  def remove_from_repository
    commit(action: :remove, message: commit_message || "Deleted #{path}")
  end

  def commit(action: :add, message:)
    Git::Commit.create(
      repository: repository,
      committer: repository.author,
      action: action,
      options: {
        commit: { message: message },
        file: { content: blob.read, path: path }
      }
    )
  end
end
