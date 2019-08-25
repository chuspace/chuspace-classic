# typed: ignore
# frozen_string_literal: true

require_relative 'boot'
require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
require 'active_support/core_ext/numeric/bytes'
require 'rails/test_unit/railtie'

Bundler.require(*Rails.groups)
Dotenv::Railtie.load

module Chuspace
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    config.generators.system_tests = nil
    config.autoloader == :zeitwerk

    # Configure rack attack
    config.middleware.use Rack::Attack unless Rails.env.test?

    # Schema format
    config.active_record.schema_format = :sql

    # Active job adapter
    config.active_job.queue_adapter = :delayed_job
    config.action_mailer.deliver_later_queue_name = 'low'
  end
end
