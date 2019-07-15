# typed: strict
# frozen_string_literal: true

module Git
  extend T::Sig

  sig { returns(GitConfig) }
  def self.config
    T.let(GitConfig.new, GitConfig)
  end
end
