# frozen_string_literal: true

require 'sawyer'

module Mobius
  class Client
    module Repos
      def user_repo(user_id)
        repos = get "users/#{user_id}/projects", owned: true, simple: true, per_page: 1
        repos.first
      end
    end
  end
end
