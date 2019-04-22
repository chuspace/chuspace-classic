# frozen_string_literal: true

class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true, email: true
  validates :name, presence: true
  validates :nickname,
            presence: true, uniqueness: true, length: { in: 1..39 }, format: { with: /\A[a-z\d][a-z\d-]*[a-z\d]\z/i }

  has_one_attached :avatar
  has_secure_token :auth_token

  has_many :ssh_keys, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :blogs, foreign_key: 'author_id', dependent: :destroy
  has_many :user_relationships, foreign_key: 'follower_id', dependent: :destroy
  has_many :followers, through: :user_relationships, source: :follower
  has_many :followings, through: :user_relationships, source: :followed
  has_many :tag_relationships, foreign_key: 'follower_id', dependent: :destroy
  has_many :taggings, through: :tag_relationships, source: :follower
  has_many :contributions, foreign_key: 'contributor_id'
  has_many :collaborations, class_name: 'Collaborator'
  has_one :default_blog, -> { where(default: true) }, foreign_key: 'author_id', class_name: 'Blog', required: true

  accepts_nested_attributes_for :default_blog

  before_validation :normalize_email_and_nickname

  def to_param
    nickname
  end

  def initials
    name.gsub(/([[:upper:]])[[:lower:]]+/, '\1').tr(' ', '')
  end

  private

  def normalize_email_and_nickname
    self.email = self.email&.downcase&.strip
    self.nickname = self.nickname&.downcase&.strip
  end
end
