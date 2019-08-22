# typed: true
# frozen_string_literal: true

module ActiveClassHelper
  def tabs_class(path)
    default_class = 'tabs__tab'
    current_page?(path) ? default_class + ' tabs__tab--active' : default_class
  end

  def link_class(path)
    default_class = 'link link--default'
    current_page?(path) ? default_class + ' link--active font-bold' : default_class
  end
end
