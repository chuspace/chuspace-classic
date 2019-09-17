# typed: true
# frozen_string_literal: true

module Reserved
  extend ActiveSupport::Concern

  WORDS = %w[
    new
    edit
    index
    terms
    chu
    settings
    ssh-keys
    ssh
    delete
    destroy
    purge
    drafts
    posts
    privacy
    session
    login
    logout
    users
    publications
    publication
    admin
    stylesheets
    stylesheet
    packs
    assets
    asset
    javascripts
    javascript
    images
    image
  ]

  included { validate :should_not_use_reserved_word }

  class_methods do
    attr_reader :reserved_attribute

    def reserved(attribute)
      @reserved_attribute = attribute
    end
  end

  private

  def should_not_use_reserved_word
    errors.add(self.class.reserved_attribute.to_sym, :taken) if WORDS.include?(send(self.class.reserved_attribute))
  end
end
