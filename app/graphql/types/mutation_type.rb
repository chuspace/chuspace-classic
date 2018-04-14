# frozen_string_literal: true

Types::MutationType = GraphQL::ObjectType.define do
  name 'Mutation'
  description 'The query root of this schema for mutating data.'

  # Repos
  field :create_repo, field: Mutations::Repos::CreateMutation.field, visibility: -> { Current.user.presence }
  # Users
  field :create_user, field: Mutations::Users::CreateMutation.field
  # Logins
  field :create_login, field: Mutations::Logins::CreateMutation.field
  # Nicknames
  field :check_nickname, field: Mutations::Nicknames::CheckMutation.field do
    cache ->(_object, args, _context) { "check_nickname_#{args['nickname']}" }
  end
end
