# frozen_string_literal: true

require 'typhoeus/adapters/faraday'

class Github
  attr_reader :token

  def initialize(token = nil)
    @token = token
  end

  def client
    client = Octokit::Client.new(access_token: token)
    client.configure do |c|
      c.middleware = faraday_stack
      c.per_page = 51
    end
    client
  end

  private
    def faraday_stack
      Faraday::RackBuilder.new do |builder|
        builder.response :logger unless Rails.env.test?
        builder.use Octokit::Response::RaiseError
        builder.request :url_encoded
        builder.request :retry
        builder.adapter :typhoeus
      end
    end
end
