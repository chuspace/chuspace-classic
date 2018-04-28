# frozen_string_literal: true

class Repo < ApplicationRecord
  include Sluggable, Repos::Github
  sluggable :name

  validates :name, :user_id, presence: true
  validates :slug, presence: true, uniqueness: { scope: :user_id }

  belongs_to :user
end
