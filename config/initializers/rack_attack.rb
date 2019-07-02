# typed: false
# frozen_string_literal: true

class Rack::Attack
  throttle('signups/ip', limit: 2, period: 5.minutes) { |req| req.ip if req.path == '/signups' && req.post? }
end
