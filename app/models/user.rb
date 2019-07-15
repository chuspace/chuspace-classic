# typed: ignore
# frozen_string_literal: true

class User < ApplicationRecord
  include AvatarUploader::Attachment.new(:avatar)
  include Trackable

  validates :email, presence: true, email: true
  validates_db_uniqueness_of :email
  validates :name, :nickname, presence: true
  validates_db_uniqueness_of :nickname
  validates length: { in: 1..39 }, format: { with: /\A^[a-z0-9]+(?:-[a-z0-9]+)*$\z/i }

  has_secure_token :auth_token

  has_many :ssh_keys, dependent: :destroy
  has_one :repository, dependent: :destroy, foreign_key: 'author_id', autosave: true
  has_many :posts, foreign_key: 'author_id', dependent: :destroy
  has_many :images, dependent: :destroy

  after_create :create_bucket
  after_destroy :delete_bucket

  alias repo repository

  def to_param
    nickname
  end

  def initials
    name.gsub(/([[:upper:]])[[:lower:]]+/, '\1').tr(' ', '')
  end

  def minio_client
    @minio_client ||= Aws::S3::Client.new
  end

  private

  def create_bucket
    minio_client.create_bucket(bucket: nickname)
  rescue Aws::S3::Errors::BucketAlreadyOwnedByYou
    true
  end

  def delete_bucket
    minio_client.delete_bucket(bucket: nickname)
  end
end
