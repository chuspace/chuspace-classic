# frozen_string_literal: true

require 'helix_runtime'

begin
  require 'markdown/native'
rescue LoadError
  warn 'Unable to load markdown/native. Please run `rake build`'
end
