# frozen_string_literal: true

class User < ApplicationRecord
  include Trackable
  include AvatarUploader::Attachment.new(:avatar)

  validates :email, presence: true, uniqueness: true, email: true
  validates :name, presence: true
  validates :nickname,
            presence: true, uniqueness: true, length: { in: 1..39 }, format: { with: /\A[a-z\d]+[-a-z\d]*[a-z\d]\z/i }

  has_secure_token :auth_token

  has_many :ssh_keys, dependent: :destroy
  has_one :invite, dependent: :destroy, autosave: true
  has_one :repository, dependent: :destroy, foreign_key: 'author_id', autosave: true
  has_many :posts, foreign_key: 'author_id', dependent: :destroy

  alias repo repository

  def to_param
    nickname
  end

  def initials
    name.gsub(/([[:upper:]])[[:lower:]]+/, '\1').tr(' ', '')
  end
end
