# frozen_string_literal: true

class User < ApplicationRecord
  include Trackable, Blogable

  validates :email, presence: true, uniqueness: true, email: true
  validates :name, presence: true
  validates :nickname,
            presence: true, uniqueness: true, length: { in: 1..39 }, format: { with: /\A[a-z\d]+[-a-z\d]*[a-z\d]\z/i }

  has_one_attached :avatar
  has_secure_token :auth_token

  has_many :ssh_keys, dependent: :destroy
  has_many :posts, foreign_key: 'author_id', dependent: :destroy
  has_many :contributions, foreign_key: 'contributor_id'

  def to_param
    nickname
  end

  def initials
    name.gsub(/([[:upper:]])[[:lower:]]+/, '\1').tr(' ', '')
  end
end
