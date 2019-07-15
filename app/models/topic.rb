# typed: ignore
# frozen_string_literal: true

class Topic < ApplicationRecord
  validates :name, presence: true
  validates_db_uniqueness_of :name

  def name=(val)
    super(val&.parameterize)
  end

  def to_param
    name
  end
end
