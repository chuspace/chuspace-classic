# frozen_string_literal: true

class ApplicationMutation < GraphQL::Schema::RelayClassicMutation
  include ApplicationInterface
end
