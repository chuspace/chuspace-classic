# typed: ignore
# frozen_string_literal: true

class Topic < ApplicationRecord
  before_validation :format_name

  validates :name, presence: true
  validates :name, format: { with: /\A^[a-z0-9]+(?:-[a-z0-9]+)*$\z/i }
  validates_db_uniqueness_of :name

  private

  def format_name
    self.name = name&.to_slug&.to_ascii&.normalize&.to_s
  end
end
