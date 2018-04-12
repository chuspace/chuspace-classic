# frozen_string_literal: true

class Schema::Helpers
  class << self
    def id_from_object(object, type)
      GraphQL::Schema::UniqueWithinType.encode(type.name, object.id, separator: '---')
    end

    def decode_object(id, scope)
      _, object_id = GraphQL::Schema::UniqueWithinType.decode(id, separator: '---')
      scope.find(object_id)
    end

    def resolve_type(obj)
      class_name = obj.class.name

      custom_resolved_type = FridaySchema.types.values.find do |value|
        value.metadata[:resolves_to_class_names].try(:include?, class_name)
      end

      custom_resolved_type || FridaySchema.types.fetch(class_name)
    end
  end
end
