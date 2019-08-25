# typed: ignore
# frozen_string_literal: true

require 'application_system_test_case'

class SignupsTest < ApplicationSystemTestCase
  include ActiveJob::TestHelper

  def setup
    @nickname = "gaurav-#{rand(0..100)}"
    @email = "gaurav-#{rand(0..100)}@chuspace.com"
  end

  test 'Creating signup' do
    visit signups_url
    assert_selector 'h3', text: 'Join Chuspace'
    assert_selector 'button', text: 'Sign up for Chuspace'

    click_button 'Sign up for Chuspace'
    assert_text "can't be blank"

    fill_in 'signup_name', with: 'Gaurav Tiwari'
    fill_in 'signup_nickname', with: 'gaurav-'
    fill_in 'signup_email', with: "gaurav-#{rand(0..100)}"
    click_button 'Sign up for Chuspace'
    assert_text 'should be all lowercase, unique, min 1 character, may have a single hyphen but cannot begin or end with a hyphen.'
    assert_text 'is not a valid email'

    fill_in 'signup_nickname', with: @nickname
    fill_in 'signup_email', with: @email

    perform_enqueued_jobs do
      click_button 'Sign up for Chuspace'
      sleep 0.1

      user = User.last
      mail = ActionMailer::Base.deliveries.last

      assert_equal user.email, mail['to'].to_s
      assert_equal "Welcome to Chuspace, #{user.name}", mail.subject
    end
  end
end
