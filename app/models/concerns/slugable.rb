# frozen_string_literal: true

# typed: false

module Slugable
  extend ActiveSupport::Concern

  included do
    before_validation :assign_slug
    validates :slug, format: { with: /\A^[a-z0-9]+(?:-[a-z0-9]+)*$\z/i }
  end

  class_methods do
    attr_reader :slug_attribute

    def sluggable(attribute)
      @slug_attribute = attribute
    end
  end

  def to_param
    slug
  end

  private

  def assign_slug
    return unless send("#{self.class.slug_attribute}_changed?") || slug.blank?
    return if send('slug_changed?')

    self.slug = send(self.class.slug_attribute)&.to_slug&.normalize&.to_s
  end
end
