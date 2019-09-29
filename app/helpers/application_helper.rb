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
      { label: 'Your profile', url: user_path(Current.user), options: {} },
      { label: 'Your publications', url: publications_path, options: {} },
      { label: 'Your posts', url: user_path(Current.user), options: {} },
      { divider: true },
      { label: 'Settings', url: settings_path, options: {} },
      { label: 'Sign out', url: signin_path(Current.user), options: { method: :delete } }
    ].map { |hash| OpenStruct.new(hash) }.freeze
  end

  def layout_class
    controller_name = params['controller'].to_sym
    action = params['action']

    layout = layout_classes_mapping[controller_name]
    layout ? layout[action.to_sym] : nil
  end

  def turbolinks_cache_control_meta_tag
    tag :meta, name: 'turbolinks-cache-control', content: @turbolinks_cache_control || 'cache'
  end

  private

  def layout_classes_mapping
    {
      posts: { edit: 'layout__narrow', new: 'layout__narrow', show: 'layout__narrow' },
      'posts/publish': { index: 'layout__narrow', create: 'layout__narrow' }
    }
  end
end
