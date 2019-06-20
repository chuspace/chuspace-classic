# typed: true
# frozen_string_literal: true

require 'test_helper'

class FastMarkdownTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::FastMarkdown::VERSION
  end

  def test_it_converts_to_html
    assert_equal FastMarkdown.to_html('# hello ds'), "<h1>hello ds</h1>\n"
  end
end
