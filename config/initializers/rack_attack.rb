# frozen_string_literal: true

class Rack::Attack
  throttle('invites/ip', limit: 2, period: 5.minutes) do |req|
    if req.path == '/invites' && req.post?
      req.ip
    end
  end
end
