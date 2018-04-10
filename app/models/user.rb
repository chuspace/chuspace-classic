# frozen_string_literal: true

class User < ApplicationRecord
  include Users::Registrable
  include Users::Activateable

  validates :email, presence: true, uniqueness: true, email: true
  validates :name, :uid, :access_token, presence: true
  has_one_attached :avatar
  has_secure_token :login_token
end
