# frozen_string_literal: true

class Types::Base::Object < GraphQL::Schema::Object
  implements GraphQL::Relay::Node.interface
  global_id_field :id
end
