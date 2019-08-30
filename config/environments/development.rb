# typed: ignore
# frozen_string_literal: true

Rails.application.configure do
  # Verifies that versions and hashed value of the package contents in the project's package.json
  config.webpacker.check_yarn_integrity = false
  # Verifies that versions and hashed value of the package contents in the project's package.json
  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Set queue adapter
  config.active_job.queue_adapter = :async

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = { 'Cache-Control' => "public, max-age=#{2.days.to_i}" }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_caching = false

  # Use mailcatcher for delivery. View emails at http://localhost:1080/
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = { host: 'localhost:5000', port: 1_025 }
  config.action_mailer.asset_host = 'http://localhost:5000'
  config.hosts << 'localhost:5000'
  config.default_url_options = { host: 'localhost:5000' }
  Rails.application.routes.default_url_options[:host] = 'localhost:5000'

  # Set default urls
  config.action_mailer.default_url_options = { host: 'localhost:5000' }

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load
  # Raises error for missing translations
  config.action_view.raise_on_missing_translations = true

  config.action_cable.url = 'ws://localhost:3334/cable'
  config.action_cable.allowed_request_origins = ['http://localhost:5000', %r{https:\/\/chuspace.*}]
end
