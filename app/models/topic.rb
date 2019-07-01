# typed: ignore
# frozen_string_literal: true

class Topic < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  def name=(val)
    super(val&.parameterize)
  end
end
