# typed: ignore
# frozen_string_literal: true

module ApplicationHelper
  def nav_items
    [
      {
        label: "Signed in as <strong>#{Current.user.nickname}</strong>",
        url: user_path(Current.user),
        active: true,
        options: { css_class: 'whitespace-normal' }
      },
      { divider: true },
      { label: 'Profile', url: user_path(Current.user), options: {} },
      { label: 'Write post', url: new_post_path, options: {} },
      { label: 'Your posts', url: user_path(Current.user), options: {} },
      { label: 'Settings', url: settings_path, options: {} },
      { divider: true },
      { label: 'Sign out', url: signin_path(Current.user), options: { method: :delete } }
    ].map { |hash| OpenStruct.new(hash) }.freeze
  end
end
