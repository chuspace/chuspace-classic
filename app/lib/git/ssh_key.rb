# frozen_string_literal: true
require 'http'
require_relative '../git'

module Git
  class SshKey
    class AccessDeniedError < StandardError; end

    BINARY = 'git_shell_authorize'

    attr_accessor :key

    def initialize(key)
      @key = key
    end

    def command
      response = HTTP.post("#{Git.config.app_url}/git_shell/auth", json:  { key: key })
      body = response.parse
      raise AccessDeniedError, "remote: No key was found for #{key}" unless body['allowed']
      body['command']
    end
  end
end
