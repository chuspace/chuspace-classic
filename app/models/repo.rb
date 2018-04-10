# frozen_string_literal: true

class Repo < ApplicationRecord
  validates :name, presence: true, uniqueness: true, scope: :user_id
  validates :github_id, :user_id, presence: true
end
