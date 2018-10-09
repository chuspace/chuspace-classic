# frozen_string_literal: true

require 'yaml'

module Mobius
  class Config
    attr_reader :config

    def initialize
      @config = YAML.load_file(File.join(app_root, 'config', 'mobius.yml'))
    end

    def app_root
      APP_ROOT
    end

    def mobius_root
      MOBIUS_ROOT
    end

    def auth_file
      @config['auth_file'] ||= File.join(app_root, '.ssh/authorized_keys')
    end

    def secret_file
      @config['secret_file'] ||= File.join(app_root, '.mobius_shell_secret')
    end

    def custom_hooks_dir(default: nil)
      @config['custom_hooks_dir'] || default
    end

    def url
      @config['url'] ||= 'http://chuspace.test'.sub(%r{/*$}, '')
    end

    def http_settings
      @config['http_settings'] ||= {}
    end

    def redis
      @config['redis'] ||= {}
    end

    def redis_namespace
      redis['namespace'] || 'resque:mobius'
    end

    def log_file
      @config['log_file'] ||= File.join(app_root, 'mobius-shell.log')
    end

    def log_level
      @config['log_level'] ||= 'INFO'
    end

    def audit_usernames
      @config['audit_usernames'] ||= false
    end

    def git_trace_log_file
      @config['git_trace_log_file']
    end

    def metrics_log_file
      @config['metrics_log_file'] ||= File.join(app_root, 'mobius-shell-metrics.log')
    end
  end
end
