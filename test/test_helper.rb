# typed: false
# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

require_relative '../config/environment'
require 'rails/test_help'
require 'simplecov'
require 'simplecov-lcov'

SimpleCov::Formatter::LcovFormatter.config.report_with_single_file = true
SimpleCov.formatter = SimpleCov::Formatter::LcovFormatter
SimpleCov.start 'rails' do
  add_filter(%r{^\/test|bin|db|config|views|javascript|lib\/})
end

class ActiveSupport::TestCase
  fixtures :all

  teardown { FileUtils.rm_rf(Git.config.storage_path) }
end
