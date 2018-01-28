# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| 'https://github.com/#{repo}.git' }

ruby '2.5.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.0.beta2'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'
# Use ActiveStorage variant
gem 'mini_magick', '~> 4.8'
# Auth
gem 'pundit'
# State machine
gem 'aasm'
# Search
gem 'searchkick'
gem 'oj'
gem 'typhoeus'
# Jobs
gem 'sidekiq'
# ENV
gem 'figaro'
# Event sourcing
gem 'delivery_boy'
gem 'racecar'
# Server side rendering
gem 'hypernova'
gem 'react-rails'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Testing
  gem 'database_cleaner'
  gem 'rspec-rails'
  gem 'factory_bot_rails'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # ERD diagrams
  gem 'rails-erd', require: false
  # Debugging
  gem 'rails_panel'
  gem 'meta_request'
  # Benchmarks
  gem 'derailed_benchmarks'
  gem 'stackprof'
  # Code linting
  gem 'rubocop', require: false
  # Security
  gem 'brakeman', require: false
  # Better messages
  gem 'awesome_print'
end

group :test do
  gem 'simplecov', require: false
  gem 'shoulda-matchers'
end
