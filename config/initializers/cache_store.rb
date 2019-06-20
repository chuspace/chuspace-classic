# typed: false
# frozen_string_literal: true

# Setup cache store for staging and production
Rails.application.configure do
  if %w[staging production].include?(Rails.env)
    Readthis.serializers << Oj
    Readthis.serializers.freeze!
    Readthis::Cache.new(marshal: Oj)

    Readthis.fault_tolerant = true

    config.cache_store =
      :readthis_store,
      {
        expires_in: 2.weeks.to_i,
        namespace: 'cache',
        compress: true,
        compression_threshold: 2.kilobytes,
        redis: { url: ENV.fetch('REDIS_URL', 'localhost:6739'), driver: :hiredis }
      }
  end
end
