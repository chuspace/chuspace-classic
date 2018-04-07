# frozen_string_literal: true

require_relative 'boot'

require 'rails'
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
require 'sprockets/railtie'

Bundler.require(*Rails.groups)

module Chuspace
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    config.generators.system_tests = nil

    config.active_job.queue_adapter = :sidekiq

    config.generators do |generate|
      generate.orm :active_record, primary_key_type: :uuid
      generate.helper false
      generate.assets false
      generate.view_specs false
    end
  end
end
