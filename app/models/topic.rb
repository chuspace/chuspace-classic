# typed: ignore
# frozen_string_literal: true

class Topic < ApplicationRecord
  validates :name, presence: true
  validates :name, format: { with: /\A^[a-z0-9]+(?:-[a-z0-9]+)*$\z/i }
  validates_db_uniqueness_of :name

  def name=(val)
    super(val&.to_slug&.to_ascii&.normalize&.to_s)
  end

  def to_param
    name
  end
end
