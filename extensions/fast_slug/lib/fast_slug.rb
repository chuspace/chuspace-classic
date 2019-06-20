# typed: strict
# frozen_string_literal: true

require 'fast_slug/version'
require 'rutie'

module FastSlug
  class Error < StandardError; end
  Rutie.new(:fast_slug).init 'Init_fast_slug', __dir__
end
