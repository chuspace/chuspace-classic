# typed: ignore
# frozen_string_literal: true

class Image < ApplicationRecord
  include ImageUploader::Attachment.new(:image)
  ROOT_PATH = 'images/.keep'

  belongs_to :repository
  belongs_to :user

  validates_uniqueness_of :blob_path, scope: %i[repository]
end
