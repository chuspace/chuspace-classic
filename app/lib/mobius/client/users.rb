# frozen_string_literal: true

require 'sawyer'

module Mobius
  class Client
    module Persons
      def person(opts = {})
        get 'person', opts
      end
    end
  end
end
