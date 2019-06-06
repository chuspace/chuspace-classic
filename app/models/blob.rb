# frozen_string_literal: true

class Blob < ApplicationRecord
  include BlobUploader::Attachment.new(:blob)

  belongs_to :repository

  validates :name, :blob_data, presence: true
  validates :path, presence: true, uniqueness: { scope: :repository_id }
end
