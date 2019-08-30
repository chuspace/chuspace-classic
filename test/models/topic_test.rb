# typed: ignore
# frozen_string_literal: true

require 'test_helper'

class TopicTest < ActiveSupport::TestCase
  def setup
    @topic = Topic.new(name: 'golang')
  end

  test 'topic without name' do
    assert @topic.valid?
  end

  test 'topic name' do
    topic = Topic.new
    refute topic.valid?
    assert_equal ["Name can't be blank", 'Name is invalid'], topic.errors.full_messages_for(:name)
  end

  test 'topic name uniqueness' do
    topic = Topic.new(name: 'ruby')
    refute topic.valid?
    assert_equal ['Name has already been taken'], topic.errors.full_messages_for(:name)
  end
end
