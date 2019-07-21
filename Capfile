# frozen_string_literal: true

# Load DSL and set up stages
require 'capistrano/setup'
require 'capistrano/deploy'
require 'capistrano/scm/git'
require 'capistrano/systemd/multiservice'
require 'capistrano/rbenv'
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
require 'capistrano/dotenv'
require 'capistrano/yarn'

Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }

install_plugin Capistrano::SCM::Git

install_plugin Capistrano::Systemd::MultiService.new_service('sidekiq')
install_plugin Capistrano::Systemd::MultiService.new_service('puma')
