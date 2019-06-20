# typed: false
# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'Valid user' do
    user = User.new
    refute user.valid?
  end
end
