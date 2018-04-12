# frozen_string_literal: true

class User < ApplicationRecord
  include Users::Registrable, Users::Github

  validates :email, presence: true, uniqueness: true, email: true
  validates :name, presence: true
  validates :nickname,
            presence: true,
            uniqueness: true,
            format: { with: /\A[a-z\d][a-z\d-]*[a-z\d]\z/i }

  has_one_attached :avatar
  has_secure_token :auth_token

  has_one :repo, dependent: :destroy

  def to_param
    nickname
  end

  def self.chuspace
    find_by(email: 'gaurav@gauravtiwari.co.uk') || first
  end
end
