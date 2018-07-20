# frozen_string_literal: true

require_relative 'boot'
require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
require 'active_support/core_ext/numeric/bytes'
# require "sprockets/railtie"
require 'rails/test_unit/railtie'

Bundler.require(*Rails.groups)

module Chuspace
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    config.generators.system_tests = nil

    config.active_job.queue_adapter = :sidekiq

    config.generators do |generate|
      generate.orm :active_record, primary_key_type: :uuid
      generate.helper false
      generate.view_specs false
    end

    # Customise readthis
    Readthis.serializers << Oj
    Readthis.serializers.freeze!
    Readthis::Cache.new(marshal: Oj)

    Readthis.fault_tolerant = true

    config.cache_store = :readthis_store, {
      expires_in: 2.weeks.to_i,
      namespace: 'cache',
      compress: true,
      compression_threshold: 2.kilobytes,
      redis: { url: ENV.fetch('REDIS_URL', 'localhost:6739'), driver: :hiredis }
    }

    # Use Vips for processing variants.
    config.active_storage.variant_processor = :vips

    config.action_mailer.preview_path = "#{Rails.root}/spec/mailers/previews"
  end
end
