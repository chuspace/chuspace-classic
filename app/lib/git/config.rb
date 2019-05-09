# frozen_string_literal: true

require 'yaml'
require 'ostruct'
require 'pathname'

module Git
  class Storage < OpenStruct; end

  class Config
    attr_reader :config

    APP_ROOT ||= File.expand_path(File.join(File.dirname(__FILE__), '../../..'))
    ROOT_PATH ||= File.join(APP_ROOT, 'app/lib/git')
    SSH_ROOT ||= File.join(APP_ROOT, '.ssh')

    def initialize
      @config = YAML.load_file(File.join(APP_ROOT, 'config', 'git.yml'))[ENV.fetch('RAILS_ENV', 'development')]
    end

    def ssh_user
      ENV.fetch('GIT_USER', 'git')
    end

    def url
      ENV.fetch('GIT_URL', 'http://chuspace.test'.sub(%r{/*$}, ''))
    end

    def storages
      fail StandardError, 'No storage configured' if @config['storages'].empty?

      @config['storages'].each_with_object([]) do |(name, path), list|
        list << Storage.new(name: name, path: Pathname.new(path))
      end
    end

    def storage
      storages.sample
    end

    def storage_path
      storage.path
    end

    def default_storage
      storages.find { |storage| storage.name == 'default' }
    end

    def storage_paths
      storages.map { |storage| storage.path }
    end

    def ssh_auth_file_name
      config['auth_key_file'] || 'authorized_keys'
    end

    def ssh_auth_file_path
      @ssh_auth_file_path ||= File.join(SSH_ROOT, ssh_auth_file_name)
    end

    def ssh_auth_lock_file_path
      @ssh_auth_lock_file_path ||= File.join(SSH_ROOT, ssh_auth_file_name + '.lock')
    end

    def log_level
      @config['log_level'] ||= 'INFO'
    end

    def log_file
      File.join(APP_ROOT, @config['log_file'])
    end
  end
end
