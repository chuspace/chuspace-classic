# frozen_string_literal: true

class Types::MutationType < ApplicationObject
  field :magic_login, mutation: Mutations::CreateMagicLogin
  field :login, mutation: Mutations::CreateLogin

  field :create_user, mutation: Mutations::CreateUser
  field :create_post, mutation: Mutations::CreatePost

  field :check_nickname, mutation: Mutations::CheckNickname
end
