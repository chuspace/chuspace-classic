# frozen_string_literal: true

require 'logger'
require_relative 'config'

def convert_log_level(log_level)
  Logger.const_get(log_level.upcase)
rescue NameError
  $stderr.puts "WARNING: Unrecognized log level #{log_level.inspect}."
  $stderr.puts 'WARNING: Falling back to INFO.'
  Logger::INFO
end

$logger = Logger.new(Mobius.config.log_file)
$logger.level = convert_log_level(Mobius.config.log_level)
