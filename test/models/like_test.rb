# typed: strong
# frozen_string_literal: true

require 'test_helper'

class LikeTest < ActiveSupport::TestCase
  def setup
    @user = create(:user)
    @post = create(:post)
  end

  test 'Should create one like per user' do
    assert @post.likes.create(user: @user)
    assert_equal @post.likes_count, 1

    refute @post.likes.build(user: @user).valid?

    assert @post.likes.find_by(user_id: @user.id).destroy
    assert_equal @post.likes_count, 0
  end
end
