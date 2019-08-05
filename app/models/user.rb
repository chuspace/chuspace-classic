# typed: ignore
# frozen_string_literal: true

class User < ApplicationRecord
  include Trackable, HasS3Bucket

  AVATAR_MAX_SIZE = 5.megabytes
  attr_accessor :avatar_blob

  validates :email, presence: true, email: true
  validates_db_uniqueness_of :email
  validates :name, :nickname, presence: true
  validates_db_uniqueness_of :nickname
  validate :should_have_correct_avatar_mime_type_size, if: -> { avatar_blob.present? }
  validates :nickname, length: { in: 1..39 }, format: { with: /\A^[a-z0-9]+(?:-[a-z0-9]+)*$\z/i }

  has_secure_token :auth_token

  has_many :ssh_keys, dependent: :destroy
  has_one :repository, dependent: :destroy, foreign_key: 'author_id', autosave: true
  has_many :posts, foreign_key: 'author_id', dependent: :destroy
  has_many :images, dependent: :destroy

  after_save :purge_old_avatar, if:  -> { saved_change_to_attribute?(:avatar) && attribute_before_last_save(:avatar) }

  alias repo repository

  def to_param
    nickname
  end

  def initials
    name.gsub(/([[:upper:]])[[:lower:]]+/, '\1').tr(' ', '')
  end

  def first_name
    name.split(' ').first
  end

  def avatar_url(**options)
    Imgproxy.url_for(s3_avatar_url, **options)
  end

  def drafts
    published_blob_paths ||= posts.pluck(:blob_path)
    repository.blobs.select { |blob| published_blob_paths.exclude?(blob.path) && blob.post? }
  end

  private

  def should_have_correct_avatar_mime_type_size
    errors.add(:avatar, :invalid_type) unless MimeMagic.by_magic(avatar_blob).image?
    errors.add(:avatar, :invalid_size) if avatar_blob.size > AVATAR_MAX_SIZE
  end

  def purge_old_avatar
    S3Service.remove_image(filename: attribute_before_last_save(:avatar))
  end
end
