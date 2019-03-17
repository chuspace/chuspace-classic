# frozen_string_literal: true

require 'yaml'

module Git
  class Config
    attr_reader :config

    def initialize
      @config = YAML.load_file(File.join(Git::APP_ROOT, 'config', 'git.yml'))
    end

    def ssh_user
      ENV.fetch('GIT_USER', 'git')
    end

    def log_level
      @config['log_level'] ||= 'INFO'
    end

    def url
      ENV.fetch('GIT_URL',  'http://chuspace.test'.sub(%r{/*$}, ''))
    end

    def git_storage_dir_name
      @config['storage_dir_name'] ||= 'git-storage'
    end

    def git_storage_path
      File.join(Git::APP_ROOT, git_storage_dir_name)
    end

    def git_storage_pathname
      Pathname.new(git_storage_path)
    end

    def ssh_auth_file
      File.join(Git::SSH_ROOT, 'authorized_keys')
    end

    def api_secret_file
      File.join(Git::APP_ROOT, 'config', @config['secret_file'])
    end

    def log_file
      File.join(Git::APP_ROOT, @config['log_file'])
    end
  end
end
