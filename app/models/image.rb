# typed: ignore
# frozen_string_literal: true

class Image < ApplicationRecord
  ROOT_PATH = 'images/.keep'

  db_belongs_to :repository
  db_belongs_to :user

  validates_presence_of :name, :blob_path
  validates_db_uniqueness_of :name, scope: %i[repository_id]
  validates_db_uniqueness_of :blob_path

  def s3_url
    "s3://#{user.nickname}/#{blob_path}"
  end

  def image_url(**options)
    Imgproxy.url_for(s3_url, **options)
  end
end
