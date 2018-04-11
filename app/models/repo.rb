# frozen_string_literal: true

class Repo < ApplicationRecord
  include Sluggable, Repos::Github

  belongs_to :user
  validates :name, :user_id, presence: true
end
