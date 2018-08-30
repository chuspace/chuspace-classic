# frozen_string_literal: true

class Post < ApplicationRecord
  include Sluggable
  sluggable :title

  belongs_to :user

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true

  before_validation :assign_slug
end
