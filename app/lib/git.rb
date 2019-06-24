# typed: true
# frozen_string_literal: true

require_relative 'git/config'

module Git
  def self.config
    @config ||= Git::Config.new
  end
end
