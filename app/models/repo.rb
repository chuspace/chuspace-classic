# frozen_string_literal: true

class Repo < ApplicationRecord
  include Sluggable, Repos::Github
  sluggable :name

  validates :slug, presence: true, uniqueness: { scope: :user_id }
  belongs_to :user
  validates :name, :user_id, presence: true
end
