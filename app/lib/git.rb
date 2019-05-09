# frozen_string_literal: true

require_relative 'git/config'

module Git
  def self.config
    @config ||= Git::Config.new
  end

  def self.logger
    @logger ||= Git::Logger.new(log_level: config.log_level, log_file: config.log_file).logger
  end
end
