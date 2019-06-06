# frozen_string_literal: true

require 'helix_runtime'

begin
  require 'slug/native'
rescue LoadError
  warn 'Unable to load slug/native. Please run `rake build`'
end
