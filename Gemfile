# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '>= 6.0.0.rc1', '<= 6.1'
gem 'bundler', '1.17.2'
# Use postgresql as the database for Active Record
gem 'pg', '>= 1.x'

# File uploads
gem 'aws-sdk-s3'
gem 'imgproxy'
gem 'fastimage'
gem 'image_processing'
gem 'ruby-vips'
gem 'shrine'

#  Nested tree
gem 'ancestry'

# Forms
gem 'simple_form'

# Use Puma as the app server
gem 'puma', '>= 3.11'

# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', github: 'rails/webpacker'

# Use Redis adapter to run Action Cable in production
gem 'redis', '>= 4.0'

# caching
gem 'hiredis'

# Auth
gem 'pundit'

# State machine
gem 'aasm'

# Search
gem 'oj'

# Jobs
gem 'sidekiq'
gem 'mini_scheduler'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Turblinks
gem 'turbolinks'
gem 'turbolinks_render'

# Git API
gem 'rugged'
gem 'charlock_holmes'

# SSH host key support
gem 'sshkey'

# Instrumentation
gem 'yabeda'

# View components
gem 'components', git: 'https://github.com/jensljungblad/components.git'

# Security
gem 'rack-attack'

# Rust extensions
gem 'fast_markdown', path: 'fast_markdown'
gem 'fast_slug', path: 'fast_slug'
gem 'faster_path'
gem 'redcarpet'

# Link previews
gem 'onebox'

group :production do
  # Resource monitoring
  gem 'easymon'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec_junit_formatter'
  gem 'coveralls', require: false
  gem 'minitest'
  gem 'dotenv-rails'
  gem 'rack-proxy'
end


group :development do
  gem 'web-console', '>= 3.3.0', require: false
  # Code linting
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  # Security
  gem 'brakeman', require: false
  # Better messages
  gem 'awesome_print'
  # Pry
  gem 'pry-rails'
  # Fake data
  gem 'faker'
  # Profiler
  gem 'rack-mini-profiler', require: false
  gem 'memory_profiler', require: false

  # gem 'sorbet'
end

group :test do
  gem 'simplecov', require: false
  gem 'simplecov-lcov', require: false
  gem 'rails-controller-testing'
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end
