# typed: strict
# frozen_string_literal: true

class Rack::Attack
  throttle('signups/ip', limit: 2, period: 5.minutes) { |req| req.ip if req.path == '/signups' && req.post? }
  throttle('signins/ip', limit: 2, period: 5.minutes) { |req| req.ip if req.path == '/signins' && req.post? }
  throttle('ahoy/ip', limit: 20, period: 1.minute) { |req| req.ip if req.path.start_with?('/ahoy/') }
end
