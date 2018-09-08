# frozen_string_literal: true

module Sluggable
  extend ActiveSupport::Concern

  included do
    before_validation :assign_slug
  end

  class_methods do
    attr_reader :slug_attribute, :slug_source

    def sluggable(attribute: :slug, source: :name)
      @slug_attribute = attribute
      @slug_source = source
    end
  end

  def to_param
    send(self.class.slug_source).parameterize
  end

  private

  def assign_slug
    send("#{self.class.slug_attribute}=", send(self.class.slug_source)&.parameterize&.downcase&.strip)
  end
end
