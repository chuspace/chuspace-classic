# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', github: 'rails/rails'

# Use postgresql as the database for Active Record
gem 'pg', '>= 1.x'

# Use Puma as the app server
gem 'puma', '>= 3.11'

# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', github: 'rails/webpacker'

# Use Redis adapter to run Action Cable in production
gem 'redis', '>= 4.0'

# Use ActiveStorage variant
gem 'image_processing'
gem 'aws-sdk-s3'
gem 'down'
gem 'http'

# caching
gem 'readthis'
gem 'hiredis'

# Auth
gem 'pundit'

# State machine
gem 'aasm'

# Search
gem 'searchkick'
gem 'oj'

# Jobs
gem 'sidekiq'

# ENV
gem 'figaro'

# oAuth
gem 'oauth2', '>= 1.4.0'
gem 'omniauth-github', '>= 1.3.0'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false
gem 'octicons_helper'

# 12 factor app
gem 'rails_12factor', group: :production

# Turblinks
gem 'turbolinks'

# Git API
gem 'rugged'
gem 'charlock_holmes'
gem 'github-linguist'

# SSH host key support
gem 'sshkey'

# Instrumentation
gem 'yabeda'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Testing
  gem 'factory_bot_rails'
  gem 'rspec_junit_formatter'
  gem 'coveralls', require: false
  gem 'webmock'

  # Rspec
  %w[rspec-core rspec-expectations rspec-mocks rspec-rails rspec-support].each do |lib|
    gem lib, github: "rspec/#{lib}"
  end
end


group :development do
  gem 'web-console', '>= 3.3.0', require: false
  # Code linting
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  # Security
  gem 'brakeman', require: false
  # Better messages
  gem 'awesome_print', require: false
  # Pry
  gem 'pry-rails', require: false
end

group :test do
  gem 'simplecov', require: false
  gem 'simplecov-lcov', require: false
  gem 'shoulda-matchers', github: 'chuspace/shoulda-matchers', branch: 'rails-6-compat'
  gem 'rails-controller-testing'
end
