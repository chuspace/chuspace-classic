# typed: ignore
# frozen_string_literal: true

require 'application_system_test_case'

class SignupsTest < ApplicationSystemTestCase
  test 'Creating signup' do
    visit signups_url
    assert_selector 'h3', text: 'Join Chuspace'
    assert_selector 'button', text: 'Sign up for Chuspace'

    click_button 'Sign up for Chuspace'
    assert_text "can't be blank"

    fill_in 'user_name', with: 'Gaurav Tiwari'
    fill_in 'user_nickname', with: 'gaurav-'
    fill_in 'user_email', with: "gaurav-#{rand(0..100)}"
    click_button 'Sign up for Chuspace'
    assert_text 'should be all lowercase, unique, min 1 character, may have a single hyphen and no special characters.'
    assert_text 'is not a valid email'

    fill_in 'user_nickname', with: "gaurav-#{rand(0..100)}"
    fill_in 'user_email', with: "gaurav-#{rand(0..100)}@chuspace.com"
    click_button 'Sign up for Chuspace'
  end
end
