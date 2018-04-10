# frozen_string_literal: true

require 'typhoeus/adapters/faraday'

class Github
  class TokenError < StandardError; end
  attr_reader :token

  def initialize(token = nil)
    fail TokenError, 'Blank token' if token.blank?
    @token = token
  end

  def create_repo(name, options = {})
    client.create_repo(name, options)
  end

  def client
    client = Octokit::Client.new(token: token)
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
