if Rails.env.staging? || Rails.env.production?
  if ENV['RAILS_LOG_TO_STDOUT'].present?
    config.lograge.enabled = true
    config.lograge.formatter = Lograge::Formatters::Json.new
    config.lograge.custom_options = -> event {
      {
       exception: event.payload[:exception],
       location: event.payload[:exception_object].backtrace.first,
       backtrace: event.payload[:exception_object].backtrace.to_json
      }
    }
  end
end
