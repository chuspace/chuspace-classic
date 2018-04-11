# frozen_string_literal: true

class Schema::Instrumentations::Cache
  def instrument(_type, field)
    return field unless field.metadata.include?(:cache_proc)

    old_resolver = field.resolve_proc
    new_resolver = -> (obj, args, ctx) do
      cache_key = field.metadata[:cache_proc].call(obj, args, ctx)

      value = get_from_cache(cache_key)
      return value if value

      value = old_resolver.call(obj, args, ctx)
      insert_into_cache(cache_key, value)
      value
    end

    field.redefine { resolve(new_resolver) }
  end

  def get_from_cache(key)
    Rails.cache.read(key)
  end

  def insert_into_cache(key, value)
    Rails.cache.write(key, value)
  end
end
