# frozen_string_literal: true

require_relative 'mobius/config'

module Mobius
  APP_ROOT ||= File.expand_path(File.join(File.dirname(__FILE__), '../..'))
  ROOT_PATH ||= File.join(APP_ROOT, 'app/lib/mobius')
  SSH_ROOT ||= File.join(APP_ROOT, '.ssh')

  def self.config
    @config ||= Mobius::Config.new
  end
end
