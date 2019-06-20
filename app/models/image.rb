# typed: ignore
# frozen_string_literal: true

class Image < ApplicationRecord
  include ImageUploader::Attachment.new(:image)

  belongs_to :repository
  validates :image_data, presence: true
  validates :blob_path, presence: true, uniqueness: { scope: :repository_id }

  def self.url_for(blob_path)
    blob_path = blob_path[1..-1] if blob_path.starts_with?('/')
    find_by(blob_path: blob_path)&.image_url(:original) || blob_path
  end
end
