# frozen_string_literal: true

module Css
  module ButtonHelper
    def button_css_classes
      {
        default: 'ba b--light-gray pa2 br2 outline-0 center bg-white black-90 pointer',
        green: 'b--light-green',
        red: 'b--light-red',
        bg_black: 'bg-black white bn',
        bg_white: 'bg-white black-90 bn'
      }.freeze
    end
  end
end
