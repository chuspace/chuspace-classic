# typed: ignore
# frozen_string_literal: true

Geocoder.configure(ip_lookup: :geoip2, geoip2: { file: Rails.root.join('db', 'GeoLite2-City.mmdb') })
