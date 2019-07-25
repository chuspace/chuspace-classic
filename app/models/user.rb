# typed: ignore
# frozen_string_literal: true

class User < ApplicationRecord
  include Trackable

  AVATAR_MAX_SIZE = 5.megabytes

  validates :email, presence: true, email: true
  validates_db_uniqueness_of :email
  validates :name, :nickname, presence: true
  validates_db_uniqueness_of :nickname
  validates :nickname, length: { in: 1..39 }, format: { with: /\A^[a-z0-9]+(?:-[a-z0-9]+)*$\z/i }

  has_secure_token :auth_token

  has_many :ssh_keys, dependent: :destroy
  has_one :repository, dependent: :destroy, foreign_key: 'author_id', autosave: true
  has_many :posts, foreign_key: 'author_id', dependent: :destroy
  has_many :images, dependent: :destroy
  has_many :contributions, foreign_key: 'editor_id', class_name: 'Edition', dependent: :destroy

  after_create do
    S3Service.create_bucket(bucket: nickname)
  rescue Aws::S3::Errors::BucketAlreadyOwnedByYou
    true
  end

  after_destroy -> { S3Service.delete_bucket(bucket: nickname) }

  alias repo repository

  def to_param
    nickname
  end

  def initials
    name.gsub(/([[:upper:]])[[:lower:]]+/, '\1').tr(' ', '')
  end

  def avatar_url(**options)
    Imgproxy.url_for(s3_avatar_url, **options)
  end

  def s3_avatar_url
    "s3://#{avatar}"
  end
end
