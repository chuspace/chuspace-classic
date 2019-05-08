# frozen_string_literal: true

class Tag < ApplicationRecord
  include Sluggable
  sluggable :name

  has_many :taggings
  has_many :posts, through: :taggings

  validates_presence_of :name
end
