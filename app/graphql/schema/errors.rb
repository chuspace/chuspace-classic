# frozen_string_literal: true

module Schema
  module Errors
    class QueryExecutionError < StandardError; end
    class QueryArgumentError < ArgumentError; end
    class UnAuthorisedError < StandardError; end
  end
end
