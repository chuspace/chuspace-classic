# frozen_string_literal: true

require 'application_system_test_case'

class InvitationsTest < ApplicationSystemTestCase
  test 'Creating invite' do
    visit root_url

    assert_selector 'label', text: 'Your email'
    assert_selector 'button', text: 'Signup'

    click_button 'Signup'
    assert_text "Email can't be blank"

    fill_in 'invite_email', with: 'gaurav'
    assert_text 'Email is not a valid email'

    fill_in 'invite_email', with: "gaurav#{rand(0...10)}@chuspace.com"
    assert_text 'We’ll never share your email address with anyone'
    click_button 'Signup'
    assert_text 'We have received your invite request.'
  end
end
