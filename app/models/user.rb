# typed: ignore
# frozen_string_literal: true

class User < ApplicationRecord
  include Trackable, AvatarUploader::Attachment.new(:avatar)

  validates :email, presence: true, email: true
  validates_db_uniqueness_of :email
  validates :name, :nickname, presence: true
  validates_db_uniqueness_of :nickname
  validates :nickname, length: { in: 1..39 }, format: { with: /\A^[a-z0-9]+(?:-[a-z0-9]+)*$\z/i }

  has_secure_token :auth_token

  has_many :ssh_keys, dependent: :destroy
  has_one :repository, dependent: :destroy, foreign_key: 'author_id', autosave: true
  has_many :posts, foreign_key: 'author_id', dependent: :destroy

  before_save :update_auth_token_expiry, if: :auth_token_changed?

  AUTH_TOKEN_EXPIRE_IN = 30

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

  def auth_token_valid?
    auth_token_expires_at.to_i >= Time.now.to_i
  end

  def drafts
    published_blob_paths ||= posts.pluck(:blob_path)
    repository.blobs.select { |blob| published_blob_paths.exclude?(blob.path) && blob.post? }
  end

  private

  def update_auth_token_expiry
    self.auth_token_expires_at = AUTH_TOKEN_EXPIRE_IN.minutes
  end
end
