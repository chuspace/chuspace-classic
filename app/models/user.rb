# typed: false
# frozen_string_literal: true

require 'mimemagic'

class User < ApplicationRecord
  include Trackable

  validates :email, presence: true, uniqueness: true, email: true
  validates :name, presence: true
  validates :nickname,
            presence: true, uniqueness: true, length: { in: 1..39 }, format: { with: /\A[a-z\d]+[-a-z\d]*[a-z\d]\z/i }

  has_secure_token :auth_token

  has_many :ssh_keys, dependent: :destroy
  has_one :invite, dependent: :destroy, autosave: true
  has_one :repository, dependent: :destroy, foreign_key: 'author_id', autosave: true
  has_many :posts, foreign_key: 'author_id', dependent: :destroy

  after_create :create_bucket
  before_destroy :delete_bucket

  alias repo repository

  def to_param
    nickname
  end

  def initials
    name.gsub(/([[:upper:]])[[:lower:]]+/, '\1').tr(' ', '')
  end

  def avatar=(avatar)
    case avatar
    when ActionDispatch::Http::UploadedFile
      path = "#{nickname}/#{uploaded_file.original_filename}"
      super(path)

      content_type = MimeMagic.by_path(avatar).type
      minio_client.put_object(key: avatar, content_type: content_type, bucket: nickname, body: uploaded_file.read)
    when String
      path = "#{nickname}/#{avatar}"
      super(path)
    else
      fail ArgumentError, 'Unsupported avatar'
    end
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
