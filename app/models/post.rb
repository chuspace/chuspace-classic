# frozen_string_literal: true

class Post < ApplicationRecord
  include Posts::Github, Sluggable
  sluggable :title

  belongs_to :user
  belongs_to :repo

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true

  before_validation :assign_slug
end
