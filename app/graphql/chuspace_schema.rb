# frozen_string_literal: true

ChuspaceSchema = GraphQL::Schema.define do
  query(Types::QueryType)
  mutation(Types::MutationType)
  subscription(Types::SubscriptionType)
  max_complexity(%w(development test).include?(Rails.env) ? 200 : 100)
  max_depth 12

  # Rescue from most common exceptions
  rescue_from ActiveRecord::ActiveRecordError, &:message
  rescue_from ActiveRecord::RecordNotFound, &:message
  rescue_from ActiveRecord::RecordInvalid, &:message
  rescue_from Schema::Errors::QueryExecutionError, &:message
  rescue_from Schema::Errors::QueryArgumentError, &:message
  rescue_from Schema::Errors::UnAuthorisedError, &:message

  # Generate/Resolve unique hex ids
  object_from_id ->(id, ctx) { Schema::Helpers.decode_object(id, scope: ctx[:scope]) }
  id_from_object ->(obj, type, _ctx) { Schema::Helpers.id_from_object(obj, type) }
  resolve_type ->(_type, obj, _ctx) { Schema::Helpers.resolve_type(obj) }

  use GraphQL::Batch
  instrument(:field, Schema::Instrumentations::Preload.new)
  instrument(:field, Schema::Instrumentations::Permission.new)
end

# Timeout if query doesn't resolve in 10 seconds
ChuspaceSchema.middleware << GraphQL::Schema::TimeoutMiddleware.new(max_seconds: 10) do |err, query|
  Rails.logger.info("GraphQL Timeout: #{query.query_string}, error: #{err}")
end
