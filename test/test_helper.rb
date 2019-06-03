# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  parallelize(workers: 4)
  fixtures :all

  teardown do
    FileUtils.rm_rf(Git.config.storage_path)
  end
end
