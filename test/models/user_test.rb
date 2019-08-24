# typed: ignore
# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'Invalid user' do
    user = User.new
    refute user.valid?
  end

  test 'Valid user' do
    user = User.new(first_name: 'Foo', last_name: 'Bar', nickname: 'foo', email: 'foo@bar.com')
    assert user.valid?
  end
end
