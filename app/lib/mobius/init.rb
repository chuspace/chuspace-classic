# frozen_string_literal: true

APP_ROOT ||= File.expand_path(File.join(File.dirname(__FILE__), '../../..'))
MOBIUS_ROOT ||= File.join(APP_ROOT, 'app/lib/mobius')
SSH_USER = 'git'

require_relative 'config'
