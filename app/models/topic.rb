# typed: ignore
# frozen_string_literal: true

class Topic < ApplicationRecord
  validates :name, presence: true
  validates_db_uniqueness_of :name

  def name=(val)
    super(val&.to_slug&.to_ascii&.normalize&.to_s)
  end

  def to_param
    name
  end
end
