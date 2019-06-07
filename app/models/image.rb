# frozen_string_literal: true

class Image < ApplicationRecord
  include ImageUploader::Attachment.new(:image)

  belongs_to :repository
  validates :image_data, presence: true
  validates :blob_path, presence: true, uniqueness: { scope: :repository_id }
end
