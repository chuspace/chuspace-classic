# frozen_string_literal: true

require 'sawyer'

module Mobius
  class Client
    module Users
      def user(opts = {})
        get 'user', opts
      end
    end
  end
end
