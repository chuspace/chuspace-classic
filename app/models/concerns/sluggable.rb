# frozen_string_literal: true

module Sluggable
  extend ActiveSupport::Concern

  included do
    validates :slug, presence: true, uniqueness: { scope: :user_id }
    before_validation :assign_slug
  end

  def to_param
    name.parameterize.join('-')
  end

  private
    def assign_slug
      self.slug = name&.parameterize
    end
end
