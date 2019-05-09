# frozen_string_literal: true

workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['RAILS_MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

rackup DefaultRackup
port ENV['PORT'] || 3000
environment ENV['RACK_ENV'] || 'development'

before_fork do
  puts 'Puma master process about to fork. Closing existing Active record connections.'
  ActiveRecord::Base.connection.disconnect!
end

on_worker_boot { ActiveRecord::Base.establish_connection }
