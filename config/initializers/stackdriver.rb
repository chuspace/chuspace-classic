Rails.application.configure do |config|
  # Shared project_id and keyfile
  config.google_cloud.project_id = "chuspace-210609"
  config.google_cloud.keyfile = ENV['STACKDRIVER_KEYFILE']

  # Library specific configurations
  config.google_cloud.use_error_reporting = %w(staging production).include?(Rails.env)
  config.google_cloud.use_trace = %w(staging production).include?(Rails.env)
  config.google_cloud.use_debugger = false
  config.google_cloud.use_logging = false

  config.google_cloud.logging.log_name = "my-app-logname"
  config.google_cloud.trace.capture_stack = true
end
