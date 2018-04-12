# frozen_string_literal: true

Types::QueryType = GraphQL::ObjectType.define do
  name 'Query'
  description 'The query root of this schema for querying data.'

  field :viewer, Types::ViewerType, 'Current viewer' do
    resolve ->(_, _, _) { Viewer::STATIC }
  end
end
