# frozen_string_literal: true

class Types::MutationType < Types::Base::Object
  field :create_post, Mutations::Posts::Create.field
  field :magic_login, Mutations::MagicLogins::Create.field
  field :check_nickname, Mutations::Nicknames::Check.field
  field :login, Mutations::Users::Login.field
  field :create_user, Mutations::Users::Create.field
end
