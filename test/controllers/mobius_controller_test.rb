# typed: ignore
# frozen_string_literal: true

require 'test_helper'

class MobiusControllerTest < ActionDispatch::IntegrationTest
  test 'should get validate' do
    get mobius_validate_url
    assert_response :success
  end
end
