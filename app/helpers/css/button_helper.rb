# frozen_string_literal: true

module Css
  module ButtonHelper
    def button_css_classes
      {
        default: 'ba b--light-gray pa2 br2 outline-0 center black-90 pointer',
        green: 'b--light-green',
        red: 'b--light-red'
      }.freeze
    end
  end
end
