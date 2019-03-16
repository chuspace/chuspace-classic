# frozen_string_literal: true

require 'net/http'
require 'openssl'
require 'json'

require_relative 'config'
require_relative 'logger'
require_relative 'access'
require_relative 'lfs_authentication'
require_relative '../httpunix'

module Mobius
  class Net
    class ApiUnreachableError < StandardError; end

    CHECK_TIMEOUT ||= 5
    READ_TIMEOUT ||= 300

    delegate :config, to: :Mobius

    def check_access(cmd, repo, actor, changes, protocol, env: {})
      changes = changes.join("\n") unless changes.kind_of?(String)

      params = {
        action: cmd,
        changes: changes,
        project: sanitize_path(repo),
        protocol: protocol,
        env: env
      }

      if actor =~ /\Akey\-\d+\Z/
        params.merge!(key_id: actor.gsub('key-', ''))
      elsif actor =~ /\Auser\-\d+\Z/
        params.merge!(user_id: actor.gsub('user-', ''))
      end

      url = "#{host}/allowed"
      resp = post(url, params)

      if resp.code == '200'
        Mobius::AccessStatus.create_from_json(resp.body)
      else
        Mobius::AccessStatus.new(false, 'API is not accessible', nil)
      end
    end

    def discover(key)
      key_id = key.gsub('key-', '')
      resp = get("#{host}/discover?key_id=#{key_id}")
      JSON.parse(resp.body) rescue nil
    end

    def broadcast_message
      resp = get("#{host}/broadcast_message")
      JSON.parse(resp.body) rescue {}
    end

    def merge_request_urls(repo_path, changes)
      changes = changes.join("\n") unless changes.kind_of?(String)
      changes = changes.encode('UTF-8', 'ASCII', invalid: :replace, replace: '')
      resp = get("#{host}/merge_request_urls?project=#{URI.escape(repo_path)}&changes=#{URI.escape(changes)}")
      JSON.parse(resp.body) rescue []
    end

    def check
      get("#{host}/check", read_timeout: CHECK_TIMEOUT)
    end

    def authorized_key(key)
      resp = get("#{host}/authorized_keys?key=#{URI.escape(key, '+/=')}")
      JSON.parse(resp.body) if resp.code == '200'
    rescue
      nil
    end

    def two_factor_recovery_codes(key)
      key_id = key.gsub('key-', '')
      resp = post("#{host}/two_factor_recovery_codes", key_id: key_id)

      JSON.parse(resp.body) if resp.code == '200'
    rescue
      {}
    end

    def notify_post_receive(repo_path)
      resp = post("#{host}/notify_post_receive", repo_path: repo_path)

      resp.code == '200'
    rescue
      false
    end

    protected

    def sanitize_path(repo)
      repo.gsub("'", '')
    end

    def host
      "#{config.url}/mobius"
    end

    def http_client_for(uri, options = {})
      http = ::Net::HTTP.new(uri.host, uri.port)
      http.read_timeout = options[:read_timeout] || read_timeout
      http
    end

    def http_request_for(method, uri, params = {})
      request_klass = method == :get ? ::Net::HTTP::Get : ::Net::HTTP::Post
      request = request_klass.new(uri.request_uri)
      request.set_form_data(params.merge(secret_token: secret_token))
      request
    end

    def request(method, url, params = {}, options = {})
      $logger.debug "Performing #{method.to_s.upcase} #{url}"

      uri = URI.parse(url)

      http = http_client_for(uri, options)
      request = http_request_for(method, uri, params)

      begin
        start_time = Time.new
        response = http.start { http.request(request) }
      rescue => e
        $logger.warn "Failed to connect to internal API <#{method.to_s.upcase} #{url}>: #{e.inspect}"
        raise ApiUnreachableError
      ensure
        $logger.info do
          sprintf('%s %s %0.5f', method.to_s.upcase, url, Time.new - start_time)
        end
      end

      if response.code == '200'
        $logger.debug "Received response #{response.code} => <#{response.body}>."
      else
        $logger.error "API call <#{method.to_s.upcase} #{url}> failed: #{response.code} => <#{response.body}>."
      end

      response
    end

    def get(url, options = {})
      request(:get, url, {}, options)
    end

    def post(url, params)
      request(:post, url, params)
    end

    def secret_token
      @secret_token ||= File.read config.api_secret_file
    end

    def read_timeout
      config.http_settings['read_timeout'] || READ_TIMEOUT
    end
  end
end
