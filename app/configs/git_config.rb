# typed: true
# frozen_string_literal: true

class GitConfig
  extend T::Sig

  sig { returns(Hash) }
  attr_reader :config

  sig { returns(Hash) }
  def initialize
    @config = T.let(Rails.application.config_for(:git), Hash)
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
    storage_path ||= T.let(config['storage_path'], String)

    if storage_path.nil?
      fail StandardError, 'No storage configured'
    else
      Pathname.new(storage_path)
    end
  end

  sig { returns(String) }
  def log_level
    config['log_level'] ||= 'INFO'
  end

  sig { returns(String) }
  def log_file
    Rails.root.join(config['log_file'])
  end
end
