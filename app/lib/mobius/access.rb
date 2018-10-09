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

    attr_reader :config, :repo_path, :changes, :protocol

    def initialize(repo_path, actor, changes, protocol)
      @config = Mobius::Config.new
      @repo_path = repo_path.strip
      @actor = actor
      @changes = changes.lines
      @protocol = protocol
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
      $stderr.puts 'Mobius: Failed to authorize your Git request: internal API unreachable'
      false
    rescue AccessDeniedError => ex
      $stderr.puts "Mobius: #{ex.message}"
      false
    end

    protected

    def api
      Mobius::Net.new
    end
  end
end
