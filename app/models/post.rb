# frozen_string_literal: true

class Post < ApplicationRecord
  include Posts::Github, Sluggable
  sluggable :title

  belongs_to :user
  belongs_to :repo

  validates :slug, presence: true, uniqueness: true
  before_validation :assign_slug
end
