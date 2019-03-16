# frozen_string_literal: true

require 'shellwords'
require 'pathname'

require_relative 'net'
require_relative 'metrics'

module Mobius
  class Shell
    class AccessDeniedError < StandardError; end
    class DisallowedCommandError < StandardError; end
    class InvalidRepositoryPathError < StandardError; end

    GIT_COMMANDS = %w(git-upload-pack git-receive-pack git-upload-archive).freeze
    BINARY = 'mobius_shell'
    MOBIUS_PROTOCOL = 'ssh'.freeze

    attr_accessor :key_id, :slug, :command, :git_access
    attr_reader :repo_path

    delegate :config, to: :Mobius

    def initialize(key_id)
      @key_id = key_id
    end

    # The origin_cmd variable contains UNTRUSTED input. If the user ran
    # ssh git@mobius.example.com 'evil command', then origin_cmd contains
    # 'evil command'.
    def exec(origin_cmd)
      unless origin_cmd
        puts "Welcome to Chuspace, #{username}!"
        return true
      end

      args = Shellwords.shellwords(origin_cmd)
      parse_cmd(args)

      if GIT_COMMANDS.include?(args.first)
        Mobius::Metrics.measure('verify-access') { verify_access }
      end

      process_cmd(args)

      true
    rescue Mobius::Net::ApiUnreachableError => ex
      $stderr.puts 'remote: Failed to authorize your Git request: internal API unreachable'
      false
    rescue AccessDeniedError => ex
      message = "remote: Access denied for git command <#{origin_cmd}> by #{log_username}."
      $logger.warn message

      $stderr.puts ex.message
      false
    rescue DisallowedCommandError => ex
      message = "remote: Attempt to execute disallowed command <#{origin_cmd}> by #{log_username}."
      $logger.warn message

      $stderr.puts 'remote: Disallowed command'
      false
    rescue InvalidRepositoryPathError => ex
      $stderr.puts 'remote: Invalid repository path'
      false
    end

    protected

    def parse_cmd(args)
      @command = args.first
      @git_access = @command

      raise DisallowedCommandError unless GIT_COMMANDS.include?(@command)
      raise DisallowedCommandError unless args.count == 2
      @slug = args.last
    end

    def verify_access
      status = api.check_access(@git_access, @slug, @key_id, '_any', MOBIUS_PROTOCOL)

      raise AccessDeniedError, status.message unless status.allowed?

      self.repo_path = status.repository_path
    end

    def process_cmd(args)
      $logger.info "executing git command <#{@command} #{repo_path}> for #{log_username}."
      exec_cmd(@command, repo_path)
    end

    # This method is not covered by Rspec because it ends the current Ruby process.
    def exec_cmd(*args)
      # If you want to call a command without arguments, use
      # exec_cmd(['my_command', 'my_command']) . Otherwise use
      # exec_cmd('my_command', 'my_argument', ...).
      if args.count == 1 && !args.first.is_a?(Array)
        raise DisallowedCommandError
      end

      env = {
        'HOME' => ENV['HOME'],
        'PATH' => ENV['PATH'],
        'LD_LIBRARY_PATH' => ENV['LD_LIBRARY_PATH'],
        'LANG' => ENV['LANG'],
        'MOBIUS_ID' => @key_id,
        'MOBIUS_PROTOCOL' => MOBIUS_PROTOCOL
      }

      if git_trace_available?
        env.merge!(
          'GIT_TRACE' => config.git_trace_log_file,
          'GIT_TRACE_PACKET' => config.git_trace_log_file,
          'GIT_TRACE_PERFORMANCE' => config.git_trace_log_file,
        )
      end

      Kernel::exec(env, *args, unsetenv_others: true)
    end

    def api
      Mobius::Net.new
    end

    def user
      return @user if defined?(@user)

      begin
        @user = api.discover(@key_id)
      rescue Mobius::Net::ApiUnreachableError
        @user = nil
      end
    end

    def username
      user && user['name'] || 'Anonymous'
    end

    def log_username
      "user with key #{@key_id}"
    end

    def lfs_authenticate
      lfs_access = api.lfs_authenticate(@key_id, @slug)

      return unless lfs_access

      puts lfs_access.authentication_payload
    end

    private

    def continue?(question)
      puts "#{question} (yes/no)"
      STDOUT.flush # Make sure the question gets output before we wait for input
      continue = STDIN.gets.chomp
      puts '' # Add a buffer in the output
      continue == 'yes'
    end

    def git_trace_available?
      return false unless config.git_trace_log_file

      if Pathname(config.git_trace_log_file).relative?
        $logger.warn "is configured to trace git commands with #{config.git_trace_log_file.inspect} but an absolute path needs to be provided"
        return false
      end

      begin
        File.open(config.git_trace_log_file, 'a') { nil }
        return true
      rescue => ex
        $logger.warn "is configured to trace git commands with #{config.git_trace_log_file.inspect} but it's not possible to write in that path #{ex.message}"
        return false
      end
    end

    def repo_path=(repo_path)
      raise ArgumentError, "Repository path not provided. Please make sure you're using Mobius v8.10 or later." unless repo_path
      raise InvalidRepositoryPathError if File.absolute_path(repo_path) != repo_path

      @repo_path = repo_path
    end
  end
end
