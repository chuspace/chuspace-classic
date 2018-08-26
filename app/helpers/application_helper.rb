# frozen_string_literal: true

module ApplicationHelper
  def component(component_name, options = {}, &block)
    name = component_name.split('_').first
    component_base = "components/#{name}"
    render("#{component_base}/#{component_name}", options, &block)
  end

  alias c component
end
