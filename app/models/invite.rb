# frozen_string_literal: true

class Invite < ApplicationRecord
  validates :email, presence: true, uniqueness: true, email: true
  validates :code, presence: true, uniqueness: true

  enum status: { invited: 0, approved: 1, accepted: 2 }
end
