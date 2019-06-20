# typed: false
# frozen_string_literal: true

module ActiveClassHelper
  def tabs_class(controller)
    default_class = 'tabs-tab-link'
    current_page?(controller: controller) ? default_class + ' tabs-tab-active' : default_class
  end
end
