# typed: ignore
# frozen_string_literal: true

class Ahoy::Store < Ahoy::DatabaseStore; end

Ahoy.api = false
Ahoy.job_queue = :low
Ahoy.visit_duration = 24.hours
Safely.report_exception_method = ->(exception) { Raven::Rack.capture_exception(exception) }
Ahoy.server_side_visits = false
