# frozen_string_literal: true

class Invite < ApplicationRecord
  validates :email, presence: true, uniqueness: true, email: true
  validates :code, uniqueness: true

  has_secure_token :code

  enum status: { invited: 0, approved: 1, accepted: 2 }
end
