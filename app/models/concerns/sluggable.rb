# frozen_string_literal: true

module Sluggable
  extend ActiveSupport::Concern

  included do
    before_validation :assign_slug
  end

  class_methods do
    attr_reader :slug_attribute

    def sluggable(attribute = :name)
      @slug_attribute = attribute
    end
  end

  def to_param
    send(self.class.slug_attribute).parameterize
  end

  private
    def assign_slug
      self.slug = send(self.class.slug_attribute)&.parameterize&.downcase&.strip unless slug.present?
    end
end
