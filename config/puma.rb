# typed: ignore
# frozen_string_literal: true

workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['RAILS_MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

early_hints true

rackup DefaultRackup
port ENV['PORT'] || 3_000
environment ENV['RACK_ENV'] || 'development'

lowlevel_error_handler do |ex, env|
  Raven.capture_exception(ex, message: ex.message, extra: { puma: env }, transaction: 'Puma')
  [
    500,
    {},
    [
      "An error has occurred, and engineers have been informed. Please reload the page. If you continue to have problems, contact hello@chuspace.com\n"
    ]
  ]
end

before_fork do
  puts 'Puma master process about to fork. Closing existing Active record connections.'
  ActiveRecord::Base.connection.disconnect!
end

on_worker_boot { ActiveRecord::Base.establish_connection }
