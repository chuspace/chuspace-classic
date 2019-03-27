# frozen_string_literal: true

require_relative 'git/config'

module Git
  APP_ROOT ||= File.expand_path(File.join(File.dirname(__FILE__), '../..'))
  ROOT_PATH ||= File.join(APP_ROOT, 'app/lib/git')
  SSH_ROOT ||= File.join(APP_ROOT, '.ssh')

  def self.config
    @config ||= Git::Config.new
  end
end
