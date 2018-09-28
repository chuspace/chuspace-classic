# frozen_string_literal: true

module Mobius
  class Client
    extend Mobius::Connection
    extend Mobius::Client::Users
    extend Mobius::Client::Repos
  end
end
