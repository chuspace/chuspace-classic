# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user
  belongs_to :repo

  validates :slug, presence: true, uniqueness: true
  before_validation :assign_slug

  def to_param
    title.parameterize
  end

  private
    def assign_slug
      self.slug = title&.parameterize
    end
end
