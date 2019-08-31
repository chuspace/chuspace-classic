# typed: ignore
# frozen_string_literal: true

class User < ApplicationRecord
  include Trackable, AvatarUploader::Attachment.new(:avatar)

  before_validation :standardise_email_and_nickname
  before_validation :build_default_publication, on: :create

  validates :email, presence: true, email: true
  validates_db_uniqueness_of :email
  validates :name, :nickname, presence: true
  validates_db_uniqueness_of :nickname
  validates :nickname, length: { in: 1..39 }, format: { with: /\A^[a-z0-9]+(?:-[a-z0-9]+)*$\z/i }
  validate :should_have_a_default_publication

  has_secure_token :auth_token

  has_many :keys, dependent: :destroy
  has_many :publications, dependent: :destroy, foreign_key: 'owner_id'
  has_many :posts, foreign_key: 'author_id', dependent: :destroy
  has_one :publication, -> { where(personal: true) }, foreign_key: 'owner_id', autosave: true, required: true

  AUTH_TOKEN_LIFE = 30

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

  def gravatar
    gravatar_id = Digest::MD5.hexdigest(email)
    "http://secure.gravatar.com/avatar/#{gravatar_id}?d=identicon"
  end

  private

  def standardise_email_and_nickname
    self.email = email&.downcase
    self.nickname = nickname&.downcase
  end

  def build_default_publication
    self.publication ||= build_publication(name: name, slug: nickname, personal: true, owner: self)
  end

  def should_have_a_default_publication
    errors.add(:publication, :invalid) if publication.blank?
  end
end
