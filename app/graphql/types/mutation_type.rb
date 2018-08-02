# frozen_string_literal: true

class Types::MutationType < ApplicationObject
  field :magic_login, 'Logs in a user from a magic login link', mutation: Mutations::CreateMagicLogin
  field :login, 'Sends magic login link to a user', mutation: Mutations::CreateLogin

  field :create_user, 'Creates a user', mutation: Mutations::CreateUser
  field :create_post, 'Creates a post', mutation: Mutations::CreatePost

  field :check_nickname, 'Checks if a nickname is taken for a user', mutation: Mutations::CheckNickname
end
