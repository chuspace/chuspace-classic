# typed: false
# frozen_string_literal: true

require 'test_helper'

class FastSlugTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::FastSlug::VERSION
  end

  def test_it_generates_correct_slug
    assert_equal FastSlug.generate('foo bar'), 'foo-bar'
  end

  def test_it_converts_non_ascii
    assert_equal FastSlug.generate('Foo^😋bar---'), 'foo-yum-bar'
    assert_equal FastSlug.generate('Foo^@bar---'), 'foo-bar'
  end
end
