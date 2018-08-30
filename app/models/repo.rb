# frozen_string_literal: true

class Repo < ApplicationRecord
  validates :name, :url, presence: true
  belongs_to :user
end
