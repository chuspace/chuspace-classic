# frozen_string_literal: true

class Types::MutationType < Types::Base::Object
  field :users::Create, Mutations::Users::Create.field
end
