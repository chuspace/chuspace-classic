# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| 'https://github.com/#{repo}.git' }

ruby '2.5.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.x'
# Use postgresql as the database for Active Record
gem 'pg'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '>= 4.x'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'
# Use ActiveStorage variant
gem 'mini_magick', '~> 4.8'
gem 'aws-sdk-s3', require: false
# Sprockets sass
gem 'sass-rails'
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
# Event sourcing
gem 'delivery_boy'
gem 'racecar'
# Server side rendering
gem 'react-rails'
gem 'mini_racer'
# Graphql
gem 'graphql'
gem 'graphql-batch'
gem 'graphql-client', git: 'https://github.com/github/graphql-client.git'
# HTML to markdown
gem 'reverse_markdown'
# Markdown
gem 'redcarpet'
gem 'html-pipeline'
gem 'rouge'
# oAuth
gem 'omniauth-github'
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
  # Pry
  gem 'pry-rails'
  gem 'pry-rescue'
  gem 'pry-stack_explorer'
end

group :test do
  gem 'simplecov', require: false
  gem 'shoulda-matchers'
  gem 'action-cable-testing'
end
