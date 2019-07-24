# typed: ignore
# frozen_string_literal: true

require 'test_helper'

class PublishedControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get published_index_url
    assert_response :success
  end
end
