# typed: ignore
# frozen_string_literal: true

class Image < ApplicationRecord
  ROOT_PATH = 'images/.keep'
  ROOT_DIRNAME = File.dirname(ROOT_PATH)
  MAX_SIZE = 15.megabytes

  db_belongs_to :repository
  db_belongs_to :user

  attr_accessor :image_blob

  validates_presence_of :name, :blob_path
  validates_db_uniqueness_of :blob_path, scope: %i[repository_id]
  validate :should_have_correct_mime_type_and_size, if: -> { image_blob.present? }

  before_validation :assign_metadata_from_blob, on: %i[create update]
  before_save :upload_image, if: -> { image_blob.present? }
  after_save :purge_old_image, if:  -> { saved_change_to_attribute?(:image) && attribute_before_last_save(:image) }
  after_destroy :purge_image

  def blob_url
    File.join('/', blob_path)
  end

  def s3_url
    "s3://#{user.s3_bucket_name}#{blob_url}"
  end

  def image_url(**options)
    Imgproxy.url_for(s3_url, **options)
  end

  private

  def assign_metadata_from_blob
    case image_blob
    when ActionDispatch::Http::UploadedFile
      self.name = image_blob.original_filename
      self.blob_path = File.join(ROOT_DIRNAME, name)
    when Git::Blob
      self.name = image_blob.name
      self.blob_path = File.join(ROOT_DIRNAME, name)
    else
      errors.add(:name, :invalid_type)
    end
  end

  def upload_image
    S3Service.upload_image(io: image_blob, filename: blob_path, bucket: user.nickname)
  end

  def should_have_correct_mime_type_and_size
    errors.add(:name, :invalid_type) unless MimeMagic.by_magic(image_blob).image?
    errors.add(:name, :invalid_size) if image_blob.size > MAX_SIZE
  end

  def purge_old_image
    S3Service.remove_image(filename: attribute_before_last_save(:name), bucket: user.s3_bucket_name)
  end

  def purge_image
    S3Service.remove_image(filename: name, bucket: user.s3_bucket_name)
  end
end
