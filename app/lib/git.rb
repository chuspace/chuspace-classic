# typed: strong
# frozen_string_literal: true

module Git
  def self.config
    GitConfig.new
  end
end
