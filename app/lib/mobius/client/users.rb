# frozen_string_literal: true

require 'sawyer'

module Mobius
  class Client
    module Users
      def user(opts = {})
        get 'user', opts
      end

      def create_user(args)
        post 'users', args
      end

      def create_user_ssh_key(sudo:, title:, key:)
        post 'user/keys', title: title, key: key, sudo: sudo
      end
    end
  end
end
