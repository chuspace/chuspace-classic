# frozen_string_literal: true

class ChuspaceSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)

  def self.id_from_object(object, type_definition, query_ctx)
    GraphQL::Schema::UniqueWithinType.encode(type_definition.name, object.id, separator: '---')
  end

  def self.object_from_id(id, query_ctx)
    _, object_id = GraphQL::Schema::UniqueWithinType.decode(id, separator: '---')
    scope.find(object_id)
  end

  def self.resolve_type(type, obj, ctx)
    class_name = obj.class.name

    custom_resolved_type = ChuspaceSchema.types.values.find do |value|
      value.metadata[:resolves_to_class_names].try(:include?, class_name)
    end

    custom_resolved_type || ChuspaceSchema.types.fetch(class_name)
  end
end
