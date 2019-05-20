# frozen_string_literal: true

FriendlyId.defaults do |config|
  config.use :reserved

  config.reserved_words = %w(
    new edit index signin signup session login logout users admin
    stylesheets assets javascripts images
  )

  config.use :history, :finders
  config.slug_limit = 255

  config.use Module.new {
    def normalize_friendly_id(text)
      text.to_slug.normalize! transliterations: %i[russian latin]
    end
  }
end
