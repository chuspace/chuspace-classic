require 'logger'

require_relative '../git'

module Git
  class Logger
    attr_accessor :log_level
    attr_reader :logger

    def initialize(log_file:, log_level:)
      @logger = ::Logger.new(@log_file)
      @log_level = log_level
      convert_log_level
    end

    private

    def convert_log_level
      ::Logger.const_get(log_level.upcase)
    rescue NameError
      $stderr.puts "WARNING: Unrecognized log level #{log_level.inspect}."
      $stderr.puts "WARNING: Falling back to INFO."
      ::Logger::INFO
    end
  end
end
