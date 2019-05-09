# frozen_string_literal: true

require 'shellwords'
require 'pathname'
require 'forwardable'
require 'http'
require_relative 'logger'

module Git
  class Shell
    extend Forwardable

    class AccessDeniedError < StandardError; end
    class DisallowedCommandError < StandardError; end
    class InvalidRepositoryPathError < StandardError; end

    GIT_COMMANDS = %w[git-upload-pack git-receive-pack git-upload-archive].freeze
    BINARY = 'git_shell'
    GIT_PROTOCOL = 'ssh'.freeze

    attr_accessor :key_id, :full_repo_name, :command, :git_access
    attr_reader :repo_path

    def_delegators :Git, :config

    def initialize(key_id)
      @key_id = key_id
    end

    # The origin_cmd variable contains UNTRUSTED input. If the user ran
    # ssh git@git.example.com 'evil command', then origin_cmd contains
    # 'evil command'.
    def exec(origin_cmd)
      unless origin_cmd
        puts "Welcome to Chuspace, #{username}!"
        return true
      end

      args = Shellwords.shellwords(origin_cmd)
      parse_cmd(args)

      verify_access if GIT_COMMANDS.include?(args.first)

      process_cmd(args)

      true
    rescue AccessDeniedError => ex
      message = "remote: Access denied for git command <#{origin_cmd}> by #{log_username}."
      Git.logger.warn message

      $stderr.puts ex.message
      false
    rescue DisallowedCommandError => ex
      message = "remote: Attempt to execute disallowed command <#{origin_cmd}> by #{log_username}."
      Git.logger.warn message

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

      @full_repo_name = args.last.split('/').last
    end

    def verify_access
      response = HTTP.post('http://chuspace.test/git_shell/access', json: { key_id: key_id, repo_name: full_repo_name })
      body = response.parse

      raise AccessDeniedError, 'remote: Unauthorized' unless body['allowed']

      self.repo_path = body['repo_path']
    end

    def process_cmd(args)
      Git.logger.info "executing git command <#{@command} #{repo_path}> for #{log_username}."
      exec_cmd(@command, repo_path)
    end

    # This method is not covered by Rspec because it ends the current Ruby process.
    def exec_cmd(*args)
      # If you want to call a command without arguments, use
      # exec_cmd(['my_command', 'my_command']) . Otherwise use
      # exec_cmd('my_command', 'my_argument', ...).
      raise DisallowedCommandError if args.count == 1 && !args.first.is_a?(Array)

      env = {
        'HOME' => ENV['HOME'],
        'PATH' => ENV['PATH'],
        'LD_LIBRARY_PATH' => ENV['LD_LIBRARY_PATH'],
        'LANG' => ENV['LANG'],
        'GIT_ID' => key_id,
        'GIT_REPO_NAME' => full_repo_name,
        'GIT_PROTOCOL' => GIT_PROTOCOL
      }

      Kernel.exec(env, *args, unsetenv_others: true)
    end

    def log_username
      "user with key #{@key_id}"
    end

    private

    def repo_path=(repo_path)
      unless repo_path
        raise ArgumentError, "Repository path not provided. Please make sure you're using Git v8.10 or later."
      end
      raise InvalidRepositoryPathError if File.absolute_path(repo_path) != repo_path

      @repo_path = repo_path
    end
  end
end
