# frozen_string_literal: true

require_relative 'init'
require_relative 'net'
require_relative 'access_status'
require_relative 'names_helper'
require_relative 'metrics'
require 'json'

module Mobius
  class Access
    class AccessDeniedError < StandardError; end
    include NamesHelper

    attr_reader :repo_path, :changes, :protocol, :api
    delegate :config, to: :Mobius

    def initialize(repo_path, actor, changes, protocol)
      @repo_path = repo_path.strip
      @actor = actor
      @changes = changes.lines
      @protocol = protocol
      @api = Mobius::Net.new
    end

    def exec
      status = Mobius::Metrics.measure('check-access:git-receive-pack') do
        env = {
          'GIT_ALTERNATE_OBJECT_DIRECTORIES' => ENV['GIT_ALTERNATE_OBJECT_DIRECTORIES'],
          'GIT_OBJECT_DIRECTORY' => ENV['GIT_OBJECT_DIRECTORY']
        }

        api.check_access('git-receive-pack', @repo_path, @actor, @changes, @protocol, env: env.to_json)
      end

      raise AccessDeniedError, status.message unless status.allowed?

      true
    rescue Mobius::Net::ApiUnreachableError
      $stderr.puts 'remote: Failed to authorize your Git request: internal API unreachable'
      false
    rescue AccessDeniedError => ex
      $stderr.puts "remote: #{ex.message}"
      false
    end
  end
end
