# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', github: 'rails/rails', ref: 'e6ef1fe056d7da084a4e8d3b817223e9a28e6200'
# Use postgresql as the database for Active Record
gem 'pg', '>= 1.x'
# Use Puma as the app server
gem 'puma', '>= 3.11'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', github: 'rails/webpacker'
# Use Redis adapter to run Action Cable in production
gem 'redis', '>= 4.0'
# Use ActiveStorage variant
gem 'ruby-vips'
gem 'bcrypt'
gem 'image_processing', '~> 1.2'
gem 'aws-sdk-s3', require: false
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
# Server side rendering
gem 'react-rails'
gem 'mini_racer'
# Github
gem 'octokit'
# HTTP requests and caching
gem 'faraday'
gem 'typhoeus'
# oAuth
gem 'oauth2', '>= 1.4.0'
gem 'omniauth-github', '>= 1.3.0'
# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :production do
  gem 'foreman'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Testing
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  %w[rspec-core rspec-expectations rspec-mocks rspec-rails rspec-support].each do |lib|
    gem lib, github: "rspec/#{lib}"
  end
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen'
  # Code linting
  gem 'rubocop', require: false
  # Security
  gem 'brakeman', require: false
  # Better messages
  gem 'awesome_print'
  # Pry
  gem 'pry-rails'
end

group :test do
  gem 'simplecov', require: false
  gem 'shoulda-matchers', github: 'thoughtbot/shoulda-matchers'
  gem 'rails-controller-testing'
end
