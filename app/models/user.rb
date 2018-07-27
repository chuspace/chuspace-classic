# frozen_string_literal: true

class User < ApplicationRecord
  include Users::Registrable, Users::Github

  validates :email, presence: true, uniqueness: true, email: true
  validates :name, presence: true
  validates :nickname,
            presence: true,
            uniqueness: true,
            length: { in: 1..39 },
            format: { with: /\A[a-z\d][a-z\d-]*[a-z\d]\z/i }

  has_one_attached :avatar
  has_one_attached :repo
  has_secure_token :auth_token

  has_one :repo, dependent: :destroy
  has_many :posts, dependent: :destroy

  before_validation :normalize_email_and_nickname

  after_create :init_git_repo

  def to_param
    nickname
  end

  def self.chuspace
    find_by(email: 'gaurav@gauravtiwari.co.uk') || first
  end

  private
    def normalize_email_and_nickname
      self.email = self.email&.downcase&.strip
      self.nickname = self.nickname&.downcase&.strip
    end

    def init_git_repo
      Git::CreateAndStoreRepo.call(user: self)
    end
end
