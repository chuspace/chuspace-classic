require "helix_runtime"

begin
  require "fast_slug/native"
rescue LoadError
  warn "Unable to load fast_slug/native. Please run `rake build`"
end
