# frozen_string_literal: true

module ActiveClassHelper
  def tabs_class(controller)
    default_class = 'tabs-tab-link'
    if current_page?(controller: controller)
      default_class + ' tabs-tab-active'
    else
      default_class
    end
  end
end
