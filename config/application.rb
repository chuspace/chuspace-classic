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
    config.autoloader == :zeitwerk

    # Configure sidekiq as background job adapter on staging and production
    config.active_job.queue_adapter = :sidekiq

    # Setup custom path for mailer previews
    config.action_mailer.preview_path = "#{Rails.root}/spec/mailers/previews"

    # Use Vips for processing variants.
    config.active_storage.variant_processor = :vips

    # Configure rack attack
    config.middleware.use Rack::Attack
  end
end
