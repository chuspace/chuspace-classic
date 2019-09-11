# frozen_string_literal: true

# typed: false

plugin 'git'
plugin 'env'
plugin 'bundler'
plugin 'rails'
plugin 'rbenv'
plugin 'nodenv'
plugin './plugins/chuspace.rb'

host 'git@chuspace.com', port: 40_423

set application: 'chuspace'
set deploy_to: '/home/git/chuspace.com'
set nodenv_node_version: '10.16.0'
set nodenv_yarn_version: '1.17.3'
set rbenv_ruby_version: '2.6-jemalloc'
set git_url: 'git@github.com:gauravtiwari/chuspace.git'
set git_branch: 'master'
set git_exclusions: %w[.tomo/ spec/ test/]

set env_vars: { RAILS_ENV: 'production', RACK_ENV: 'production', SECRET_KEY_BASE: :prompt, DATABASE_URL: :prompt }

set linked_dirs: %w[.bundle log node_modules public/assets public/packs cache bin/git-hooks]

setup do
  run 'env:setup'
  run 'core:setup_directories'
  run 'git:clone'
  run 'git:create_release'
  run 'core:symlink_shared'
  run 'nodenv:install'
  run 'bundler:upgrade_bundler'
  run 'bundler:install'
  run 'rails:db_create'
  run 'rails:db_structure_load'
  run 'rails:db_seed'
end

deploy do
  run 'env:update'
  run 'git:create_release'
  run 'core:symlink_shared'
  run 'core:write_release_json'
  run 'bundler:install'
  run 'rails:db_migrate'
  run 'rails:db_seed'
  run 'rails:assets_precompile'
  run 'core:symlink_current'
  run 'core:clean_releases'
  run 'bundler:clean'
  run 'core:log_revision'
  run 'chuspace:copy_env_vars'
  run 'chuspace:copy_sshd_config'
  run 'chuspace:compile_mobius'
  run 'chuspace:restart_puma_and_anycable'
end
