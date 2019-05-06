# frozen_string_literal: true

require 'yaml'

module Git
  class Config
    attr_reader :config

    APP_ROOT ||= File.expand_path(File.join(File.dirname(__FILE__), '../../..'))
    ROOT_PATH ||= File.join(APP_ROOT, 'app/lib/git')
    SSH_ROOT ||= File.join(APP_ROOT, '.ssh')

    def initialize
      @config = YAML.load_file(File.join(APP_ROOT, 'config', 'git.yml'))['development']
    end

    def ssh_user
      ENV.fetch('GIT_USER', 'git')
    end

    def url
      ENV.fetch('GIT_URL', 'http://chuspace.test'.sub(%r{/*$}, ''))
    end

    def repositories_dirname
      @config['storage_dir_name'] ||= 'repositories'
    end

    def repositories_path
      File.join(APP_ROOT, repositories_dirname)
    end

    def ssh_auth_file_name
      config['auth_key_file'] || 'authorized_keys'
    end

    def ssh_auth_file_path
      @ssh_auth_file_path ||= File.join(Git::SSH_ROOT, ssh_auth_file_name)
    end

    def ssh_auth_lock_file_path
      @ssh_auth_lock_file_path ||= File.join(Git::SSH_ROOT, ssh_auth_file_name + '.lock')
    end

    def log_level
      @config['log_level'] ||= 'INFO'
    end

    def log_file
      File.join(APP_ROOT, @config['log_file'])
    end
  end
end
