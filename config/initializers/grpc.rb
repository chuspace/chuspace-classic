Gruf.configure do |c|
  c.default_client_host = "#{ENV['MOBIUS_SERVICE_HOST']}:#{ENV['MOBIUS_SERVICE_PORT']}"
end
