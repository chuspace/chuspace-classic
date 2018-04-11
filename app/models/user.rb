# frozen_string_literal: true

class User < ApplicationRecord
  include Users::Registrable, Users::Github

  validates :email, presence: true, uniqueness: true, email: true
  validates :name, presence: true
  has_one_attached :avatar
  has_secure_token :login_token

  has_one :repo, dependent: :destroy

  def to_param
    nickname
  end
end
