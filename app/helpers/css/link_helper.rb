# frozen_string_literal: true

module Css
  module LinkHelper
    def link_css_classes
      {
        default: 'black-90 no-underline hover-near-black',
        green: 'green hover-light-green',
        red: 'red hover-light-red',
        gray: 'dark-gray hover-mid-gray'
      }.freeze
    end
  end
end
