# frozen_string_literal: true

module Mobius
  class Client
    include Mobius::Connection
    include Mobius::Client::Users
    include Mobius::Client::Repos

    attr_accessor :access_token

    def initialize
      @access_token = ENV['GIT_API_TOKEN']
    end
  end
end
