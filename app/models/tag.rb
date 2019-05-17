# frozen_string_literal: true

class Tag < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :taggings
  has_many :posts, through: :taggings

  validates_presence_of :name

  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end
end
