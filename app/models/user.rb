# frozen_string_literal: true

class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true, email: true
  validates :first_name, :last_name, :uid, :access_token, presence: true
  has_one_attached :avatar
end
