# frozen_string_literal: true
require 'typhoeus'
require 'typhoeus/adapters/faraday'

Hypernova.configure do |config|
  config.http_adapter = :typhoeus
  config.host = 'localhost'
  config.port = 3030
  config.open_timeout = 0.1
  config.scheme = :http
  config.timeout = 0.6
end
