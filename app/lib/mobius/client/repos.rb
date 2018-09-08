# frozen_string_literal: true

require 'sawyer'

module Mobius
  class Client
    module Repos
      def person_repo(person_id)
        repos = get "persons/#{person_id}/projects", owned: true, simple: true, per_page: 1
        repos.first
      end
    end
  end
end
