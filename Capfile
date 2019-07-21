# frozen_string_literal: true

# Load DSL and set up stages
require 'capistrano/setup'
require 'capistrano/deploy'
require 'capistrano/scm/git'
require 'capistrano/systemd/multiservice'
require 'capistrano/dotenv'
require 'capistrano/rbenv'
require 'capistrano/nodenv'
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'

install_plugin Capistrano::SCM::Git

install_plugin Capistrano::Systemd::MultiService.new_service('sidekiq')
install_plugin Capistrano::Systemd::MultiService.new_service('puma')

Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
