# frozen_string_literal: true

class Blob < ApplicationRecord
  ALLOWED_EXTENSIONS = %w(.md .jpg .jpeg .png .gif)

  include BlobUploader::Attachment.new(:blob)

  belongs_to :repository
  has_one :post, dependent: :destroy

  validates :blob_data, presence: true
  validates :path, presence: true, uniqueness: { scope: :repository_id }
  validate :validate_extname

  before_validation :assign_filename

  def content
    @content ||= blob.read.force_encoding('UTF-8')
  end

  def commit(action: :add, message:)
    message ||= case action
                when :add
                  "Created #{path}"
                when :update
                  "Updated #{path}"
                when :remove
                  "Deleted #{path}"
    end

    Git::Commit.create(
      repository: repository,
      committer: repository.author,
      action: action,
      options: {
        commit: { message: message },
        file: { content: content, path: path }
      }
    )
  end

  private

  def assign_filename
    blob.metadata['filename'] = FasterPath.basename(path) unless blob.is_a?(Hash)
  end

  def validate_extname
    extname = FasterPath.extname(path)
    errors.add(:path, :invalid, message: 'must be Markdown(.md), JPEG, PNG or GIF') unless ALLOWED_EXTENSIONS.include?(extname)
  end
end
