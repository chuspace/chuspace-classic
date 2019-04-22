# frozen_string_literal: true

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'rspec/rails'
require 'shoulda/matchers'
require 'simplecov'
require 'simplecov-lcov'

SimpleCov::Formatter::LcovFormatter.config.report_with_single_file = true
SimpleCov.formatter = SimpleCov::Formatter::LcovFormatter
SimpleCov.start 'rails' do
  add_filter(%r{^\/spec|bin|db|config|views|javascript|lib\/})
end

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!
ActiveJob::Base.queue_adapter = :test

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include(Shoulda::Matchers::ActiveModel, type: :model)
  config.include(Shoulda::Matchers::ActiveRecord, type: :model)
  config.include JsonHelper, type: :controller
  config.include JsonHelper, type: :request

  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.raise_errors_for_deprecations!
  config.example_status_persistence_file_path = 'rspec_failures.txt'

  config.mock_with :rspec do |mocks|
    mocks.allow_message_expectations_on_nil = true
  end

  config.before(:each, type: :system) { driven_by :rack_test }

  config.before(:each, type: :system, js: true) { driven_by :selenium_chrome_headless }

  config.after(:all) do
    FileUtils.rm_rf(Git.config.git_storage_path)
    FileUtils.rm_rf(Git.config.ssh_auth_file_path)
    FileUtils.rm_rf(Git.config.ssh_auth_lock_file_path)
  end

  config.order = 'random'
  config.include ActiveSupport::Testing::TimeHelpers
end
