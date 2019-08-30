# typed: strict
# frozen_string_literal: true

class Rack::Attack
  throttle('signups/ip', limit: 2, period: 5.minutes) { |req| req.ip if req.path == '/signups' && req.post? }
  throttle('signins/ip', limit: 2, period: 5.minutes) { |req| req.ip if req.path == '/signins' && req.post? }
  throttle('signins/tokens/ip', limit: 2, period: 5.minutes) do |req|
    req.ip if req.path == '/signin/token' && req.post?
  end
end
