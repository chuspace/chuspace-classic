# typed: strict
# frozen_string_literal: true

# Define an application-wide content security policy
# For further information see the following documentation
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy

if Rails.env.production?
  Rails.application.config.content_security_policy do |p|
    p.default_src :self, :https, :wss, '*.chuspace.com'
    p.font_src :self, :https, :data
    p.img_src :self, :https, :data, 'secure.gravatar.com'
    p.object_src :none
    p.script_src :self, :https, :unsafe_inline, 'assets.chuspace.com'
    p.style_src :self,
                :https,
                :unsafe_inline,
                'assets.chuspace.com',
                'https://cdn.jsdelivr.net/gh/tonsky/FiraCode@1.206/distr/fira_code.css',
                'https://use.typekit.net/oyz0gkh.css',
                'https://cdn.jsdelivr.net/gh/tonsky/FiraCode@1.206/distr/fira_code.css',
                'https://use.typekit.net/oyz0gkh.css'
    # Specify URI for violation reports
    # p.report_uri "/csp-violation-report-endpoint"
  end
end

# Report CSP violations to a specified URI
# For further information see the following documentation:
# https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy-Report-Only
# Rails.application.config.content_security_policy_report_only = true
