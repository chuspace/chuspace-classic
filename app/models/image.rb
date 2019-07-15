# typed: ignore
# frozen_string_literal: true

class Image < ApplicationRecord
  include ImageUploader::Attachment.new(:image)
  ROOT_PATH = 'images/.keep'

  db_belongs_to :repository
  db_belongs_to :user

  validates_db_uniqueness_of :blob_path, scope: %i[repository]
end
