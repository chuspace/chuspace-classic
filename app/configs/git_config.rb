# typed: false
# frozen_string_literal: true

class GitConfig
  attr_reader :config

  def initialize
    @config = Rails.application.config_for(:git)
  end

  def ssh_user
    ENV.fetch('GIT_USER', 'git')
  end

  def app_url
    ENV.fetch('APP_URL', 'http://chuspace.test'.sub(%r{/*$}, ''))
  end

  def storage_path
    storage_path ||= config['storage_path']

    if storage_path.nil?
      fail StandardError, 'No storage configured'
    else
      Pathname.new(storage_path)
    end
  end

  def log_level
    config['log_level'] ||= 'INFO'
  end

  def log_file
    Rails.root.join(config['log_file'])
  end
end
