# frozen_string_literal: true

require 'lograge'

Rails.application.configure do |config|
  if ENV['RAILS_LOG_TO_STDOUT'].present?
    config.log_formatter = ::Logger::Formatter.new
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
    config.lograge.enabled = true
  end
end
