# typed: false
# frozen_string_literal: true

module ApplicationHelper
  def nav_items
    [
      {
        label: "Signed in as <strong>#{Current.user.nickname}</strong>",
        url: user_url(Current.user),
        active: true,
        options: { css_class: 'whitespace-normal' }
      },
      { divider: true },
      { label: 'Profile', url: user_url(Current.user), options: {} },
      { label: 'Write post', url: new_post_url, options: {} },
      { label: 'Settings', url: settings_url, options: {} },
      { divider: true },
      { label: 'Sign out', url: signin_url(Current.user), options: { method: :delete } }
    ].map { |hash| OpenStruct.new(hash) }.freeze
  end
end
