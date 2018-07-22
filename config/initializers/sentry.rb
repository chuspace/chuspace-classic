# frozen_string_literal: true

if Rails.env.production?
  Raven.configure do |config|
    config.dsn = 'https://5b36cb41398f4152abd7c47e4f77f797:024b1bb8cea84dcc91cd0a29a6595608@sentry.io/1247671'

    config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
  end
end
