# frozen_string_literal: true

class Image < ApplicationRecord
  include ImageUploader::Attachment.new(:image)
  UPLOAD_PATH = 'git-assets'

  belongs_to :repository

  validates :name, presence: true, uniqueness: { scope: :repository_id }
  validates :blob_path, presence: true, uniqueness: { scope: :repository_id }

  def to_param
    name
  end

  def blob
    @blob ||= repository.blob_at(path: blob_path)
  end
end
