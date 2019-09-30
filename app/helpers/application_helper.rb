# typed: ignore
# frozen_string_literal: true

module ApplicationHelper
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
