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

    # Configure sidekiq as background job adapter on staging and production
    config.active_job.queue_adapter = :sidekiq

    # Setup custom path for mailer previews
    config.action_mailer.preview_path = "#{Rails.root}/spec/mailers/previews"

    # Configure rack attack
    config.middleware.use Rack::Attack unless Rails.env.test?

    # Schema format
    config.active_record.schema_format = :sql

    # Setup default urls
    config.action_mailer.asset_host = 'http://assets.chuspace.com'
    config.hosts << 'chuspace.com'
    config.default_url_options = { host: 'chuspace.com' }
    Rails.application.routes.default_url_options[:host] = 'chuspace.com'
  end
end
