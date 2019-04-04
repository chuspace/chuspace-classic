# frozen_string_literal: true

require 'yaml'

module Git
  class Config
    attr_reader :config

    def initialize
      @config = YAML.load_file(Rails.root.join('config', 'git.yml'))[Rails.env]
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
      Rails.root.join(git_storage_dir_name)
    end

    def ssh_auth_file_name
      config['auth_key_file'] || 'authorized_keys'
    end

    def ssh_auth_file_path
      Pathname.new(Git::SSH_ROOT).tap(&:mkpath)
      @ssh_auth_file_path ||= Rails.root.join(Git::SSH_ROOT, ssh_auth_file_name)
      FileUtils.touch(@ssh_auth_file_path) unless File.exists?(@ssh_auth_file_path)
      @ssh_auth_file_path
    end

    def ssh_auth_lock_file_path
      @ssh_auth_lock_file_path ||= Rails.root.join(Git::SSH_ROOT, ssh_auth_file_name + '.lock')
      FileUtils.touch(@ssh_auth_lock_file_path) unless File.exists?(@ssh_auth_lock_file_path)
      @ssh_auth_lock_file_path
    end

    def log_file
      Rails.root.join(@config['log_file'])
    end
  end
end
