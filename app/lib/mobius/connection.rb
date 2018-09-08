# frozen_string_literal: true

require 'sawyer'
require 'typhoeus'
require 'typhoeus/adapters/faraday'

module Mobius
  module Connection
    CONVENIENCE_HEADERS = Set.new([:accept, :content_type])
    API_ENDPOINT = 'https://git.problemwall.com/api/v4'.freeze
    USER_AGENT   = "Chuspace #{Mobius::VERSION}".freeze
    MEDIA_TYPE   = 'application/vnd.github.v3+json'.freeze
    RACK_BUILDER_CLASS = defined?(Faraday::RackBuilder) ? Faraday::RackBuilder : Faraday::Builder

    MIDDLEWARE = RACK_BUILDER_CLASS.new do |builder|
      builder.use Faraday::Request::Retry
      builder.use Mobius::Middlewares::RaiseError
      builder.use :http_cache, store: Rails.cache, shared_cache: false
      builder.response :logger do | logger |
        logger.filter(/(Private-token:).*"(.+)."/, '\1[TOKEN]')
      end
      builder.adapter :typhoeus
    end

    def get(url, options = {})
      request :get, url, parse_query_and_convenience_headers(options)
    end

    def post(url, options = {})
      request :post, url, options
    end

    def put(url, options = {})
      request :put, url, options
    end

    def patch(url, options = {})
      request :patch, url, options
    end

    def delete(url, options = {})
      request :delete, url, options
    end

    def head(url, options = {})
      request :head, url, parse_query_and_convenience_headers(options)
    end

    def agent
      @agent ||= Sawyer::Agent.new(endpoint, sawyer_options)
    end

    def root
      get '/'
    end

    def last_response
      @last_response if defined? @last_response
    end

    protected

    def endpoint
      API_ENDPOINT
    end

    def user_agent
      USER_AGENT
    end

    def media_type
      MEDIA_TYPE
    end

    private

    def reset_agent
      @agent = nil
    end

    def request(method, path, data, options = {})
      if data.is_a?(Hash)
        options[:query]   = data.delete(:query) || {}
        options[:headers] = data.delete(:headers) || {}
        if accept = data.delete(:accept)
          options[:headers][:accept] = accept
        end
      end

      @last_response = response = agent.call(method, Addressable::URI.parse(path.to_s).normalize.to_s, data, options)
      response.data
    end

    def boolean_from_response(method, path, options = {})
      request(method, path, options)
      @last_response.status == 204
    rescue Mobius::NotFound
      false
    end

    def connection_opts
      {
        headers: {
          accept: media_type,
          user_agent: user_agent,
          content_type: 'application/json',
          'Private-token': @access_token
        }
      }
    end

    def sawyer_options
      opts = {
        links_parser: Sawyer::LinkParsers::Simple.new
      }

      conn_opts = connection_opts
      conn_opts[:builder] = MIDDLEWARE
      opts[:faraday] = Faraday.new(conn_opts)

      opts
    end

    def parse_query_and_convenience_headers(options)
      options = options.dup
      headers = options.delete(:headers) { Hash.new }

      CONVENIENCE_HEADERS.each do |h|
        if header = options.delete(h)
          headers[h] = header
        end
      end

      query = options.delete(:query)
      opts = { query: options }

      opts[:query].merge!(query) if query && query.is_a?(Hash)
      opts[:headers] = headers unless headers.empty?

      opts
    end
  end
end
