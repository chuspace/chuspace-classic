# frozen_string_literal: true

require 'simplecov'

SimpleCov.start 'rails' do
  add_filter '/vendor/bundle/'

  add_group 'Consumers', '/app/consumers'
  add_group 'Services', '/app/services'
  add_group 'Jobs', '/app/jobs'
  add_group 'Policies', '/app/policies'
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
