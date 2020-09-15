# typed: ignore
# frozen_string_literal: true

class DropdownComponent < ApplicationComponent
  DEFAULT_CSS_CLASS = 'dropdown'
  with_content_areas :opener, :body

  attr_reader :items, :drop_arrow, :css_class

  def initialize(drop_arrow: :yes, css_class: nil)
    @items = items
    @drop_arrow = drop_arrow
    @css_class = css_class
  end

  def arrow?
    drop_arrow == :yes
  end

  def css_classes
    classes = [DEFAULT_CSS_CLASS]
    classes << css_class if css_class
    classes.join(' ')
  end
end
