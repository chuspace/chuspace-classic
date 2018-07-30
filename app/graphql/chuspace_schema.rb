# frozen_string_literal: true

class ChuspaceSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)
end
