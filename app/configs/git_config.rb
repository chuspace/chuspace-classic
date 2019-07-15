# typed: true
# frozen_string_literal: true

class GitConfig
  extend T::Sig

  attr_reader :config

  sig { returns(GitConfig) }
  def initialize
    @config = Rails.application.config_for(:git)
  end

  sig { returns(String) }
  def ssh_user
    ENV.fetch('GIT_USER', 'git')
  end

  sig { returns(String) }
  def app_url
    ENV.fetch('APP_URL', 'http://chuspace.test'.sub(%r{/*$}, ''))
  end

  sig { returns(Pathname) }
  def storage_path
    @storage_path ||= @config['storage_path']
    fail StandardError, 'No storage configured' if @storage_path.nil?

    Pathname.new(@storage_path)
  end

  sig { returns(Integer) }
  def log_level
    @config['log_level'] ||= 'INFO'
  end

  sig { returns(String) }
  def log_file
    Rails.root.join(@config['log_file'])
  end
end
