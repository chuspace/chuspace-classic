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
require 'rails/test_unit/railtie'

Bundler.require(*Rails.groups)

module Chuspace
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    config.generators.system_tests = nil

    # Background job adapter
    config.active_job.queue_adapter = :sidekiq

    # Reduce generator noise
    config.generators do |generate|
      generate.orm :active_record, primary_key_type: :uuid
      generate.helper false
      generate.assets false
      generate.view_specs false
    end

    # Use Vips for processing variants.
    config.active_storage.variant_processor = :vips

    # Setup custom path for mailer previews
    config.action_mailer.preview_path = "#{Rails.root}/spec/mailers/previews"

    config.google_cloud.project_id = "chuspace-210609"
    config.google_cloud.keyfile = ENV['STACKDRIVER_KEYFILE']

    config.google_cloud.use_error_reporting = %w(staging production).include?(Rails.env)
    config.google_cloud.use_trace = %w(staging production).include?(Rails.env)
    config.google_cloud.use_debugger = false
    config.google_cloud.use_logging = false

    config.google_cloud.logging.log_name = "my-app-logname"
    config.google_cloud.trace.capture_stack = true

    if Rails.env.test?
      config.cache_store = :memory_store
    else
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
    end
  end
end
