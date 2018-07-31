# frozen_string_literal: true

class ChuspaceSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)

  def self.id_from_object(object, type_definition, query_ctx)
    Schema::Helpers.id_from_object(type_definition, object)
  end

  def self.object_from_id(id, query_ctx)
    Schema::Helpers.decode_object(id, scope: query_ctx[:scope])
  end
end
