# typed: true
# frozen_string_literal: true

module Git
  def self.config
    @config ||= GitConfig.new
  end
end
