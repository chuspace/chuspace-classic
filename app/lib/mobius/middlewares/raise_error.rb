# frozen_string_literal: true

require 'faraday'

module Mobius
  module Middlewares
    class RaiseError < Faraday::Response::Middleware
      private
      def on_complete(response)
        if error = Mobius::Error.from_response(response)
          raise error
        end
      end
    end
  end
end
