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

    # Use Vips for processing variants.
    config.active_storage.variant_processor = :vips

    # Configure sidekiq as background job adapter on staging and production
    config.active_job.queue_adapter = :sidekiq

    # Configure google cloud error reporting
    config.google_cloud.project_id = 'chuspace-210609'
    config.google_cloud.keyfile = ENV['STACKDRIVER_KEYFILE']

    config.google_cloud.use_error_reporting = %w(staging production).include?(Rails.env)
    config.google_cloud.use_trace = %w(staging production).include?(Rails.env)
    config.google_cloud.use_debugger = false
    config.google_cloud.use_logging = false

    config.google_cloud.trace.capture_stack = true

    # Load additional paths
    config.eager_load_paths << config.root.join('lib', 'mobius')
    # Setup custom path for mailer previews
    config.action_mailer.preview_path = "#{Rails.root}/spec/mailers/previews"
  end
end
