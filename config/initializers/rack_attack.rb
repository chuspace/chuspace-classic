# typed: strict
# frozen_string_literal: true

class Rack::Attack
  throttle('invites/ip', limit: 2, period: 5.minutes) { |req| req.ip if req.path == '/invites' && req.post? }
end
