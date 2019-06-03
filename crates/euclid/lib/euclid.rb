require 'helix_runtime'

begin
  require 'euclid/native'
rescue LoadError
  warn 'Unable to load euclid/native. Please run `rake build`'
end
