# frozen_string_literal: true

class Schema::Instrumentations::Permission
  def instrument(_type, field)
    return field unless field.metadata.include?(:visibility_proc)

    new_resolver = lambda do |obj, args, ctx|
      visible = field.metadata[:visibility_proc].call(obj, args, ctx)
      return nil unless visible
      field.resolve_proc.call(obj, args, ctx)
    end

    field.redefine { resolve(new_resolver) }
  end
end
