# typed: ignore
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

    def initialize
      @config = YAML.load_file(File.join(APP_ROOT, 'config', 'git.yml'))[ENV.fetch('RAILS_ENV', 'development')]
    end

    def ssh_user
      ENV.fetch('GIT_USER', 'git')
    end

    def app_url
      ENV.fetch('APP_URL', 'http://chuspace.test'.sub(%r{/*$}, ''))
    end

    def storage_path
      @storage_path ||= @config['storage_path']
      fail StandardError, 'No storage configured' if @storage_path.nil?

      Pathname.new(@storage_path)
    end

    def log_level
      @config['log_level'] ||= 'INFO'
    end

    def log_file
      File.join(APP_ROOT, @config['log_file'])
    end
  end
end
