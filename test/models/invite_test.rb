# frozen_string_literal: true

require 'test_helper'

class InviteTest < ActiveSupport::TestCase
  test 'Valid user' do
    invite = Invite.new
    refute invite.valid?
  end
end
