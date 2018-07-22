# frozen_string_literal: true

require 'lograge'

Rails.application.configure do |config|
  if ENV['RAILS_LOG_TO_STDOUT'].present?
    config.lograge.enabled = true
  end
end
