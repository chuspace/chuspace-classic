# frozen_string_literal: true

class Post < ApplicationRecord
  include Sluggable
  sluggable source: :title

  belongs_to :person
  belongs_to :blog

  validates :status, presence: true
  validates :slug, presence: true, uniqueness: true

  enum status: {
    draft: 0,
    published: 1,
    archived: 2
  }

  before_validation :assign_slug

  delegate :blog, to: :person
end
