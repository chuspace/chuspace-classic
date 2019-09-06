# typed: ignore
# frozen_string_literal: true

class User < ApplicationRecord
  include Trackable, AvatarUploader::Attachment.new(:avatar)

  before_validation :standardise_email_and_nickname, if: -> { email_changed? || nickname_changed? }

  validates :email, presence: true, email: true
  validates_db_uniqueness_of :email
  validates :name, :nickname, presence: true
  validates_db_uniqueness_of :nickname
  validates :nickname, length: { in: 1..39 }, format: { with: /\A^[a-z0-9]+(?:-[a-z0-9]+)*$\z/i }
  validate :should_have_a_default_publication

  has_secure_token :auth_token
  has_person_name

  has_many :keys, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :collaborations, class_name: 'Collaborator', dependent: :destroy
  has_many :publications, through: :collaborations, class_name: 'Publication', source: :publication, dependent: :destroy
  has_many :posts, foreign_key: 'author_id', dependent: :destroy
  has_many :drafts, -> { where(status: :draft) }, class_name: 'Post', foreign_key: 'author_id', dependent: :destroy
  has_one :publication, -> { where(personal: true) }, foreign_key: 'owner_id', autosave: true, required: true

  AUTH_TOKEN_LIFE = 30

  def self.search(query:)
    sql = <<-SQL
      unaccent(users.name) ILIKE unaccent('%#{query}%') OR
      unaccent(users.nickname) ILIKE unaccent('%#{query}%') OR
      unaccent(users.email) ILIKE unaccent('%#{query}%')
    SQL

    where(sql)
  end

  def to_param
    nickname
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

  def should_have_a_default_publication
    errors.add(:publication, :invalid) if publication.blank?
  end
end
