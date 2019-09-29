# typed: strong
# frozen_string_literal: true

require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def setup
    @post = create(:post)
  end

  test 'post should have a blob' do
    assert @post.blob.persisted?
    assert_equal @post.blob_path, @post.blob.path
  end
end
