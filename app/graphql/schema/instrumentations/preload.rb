# frozen_string_literal: true

module Schema
  module Instrumentations
    class Preload
      def instrument(_type, field)
        return field unless field.metadata.include?(:preload)

        old_resolver = field.resolve_proc
        new_resolver = lambda do |object, args, ctx|
          preload(object, field.metadata[:preload]).then do
            old_resolver.call(object, args, ctx)
          end
        end

        field.redefine do
          resolve(new_resolver)
        end
      end

      private

        def preload(object, associations)
          if associations.is_a?(Symbol)
            preload_association(object, associations)
          else
            promises = []

            Array.wrap(associations).each do |value|
              case value
              when Symbol
                promises << preload_association(object, value)
              when Array
                value.each { |sub_value| promises << preload(object, sub_value) }
              when Hash
                value.each do |key, sub_value|
                  promises << preload_association(object, key).then do
                    next_value = object.public_send(key)
                    preload_hash(next_value, sub_value)
                  end
                end
              end
            end

            Promise.all(promises)
          end
        end

        def preload_association(object, association)
          return Promise.resolve(object) if object.association(association).loaded?
          Loaders::AssociationLoader.for(object.class, association).load(object)
        end

        def preload_hash(next_value, sub_value)
          case next_value
          when ActiveRecord::Base
            preload(next_value, sub_value)
          else
            Promise.all(Array.wrap(next_value).map { |next_model| preload(next_model, sub_value) })
          end
        end
    end
  end
end
