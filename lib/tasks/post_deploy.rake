# frozen_string_literal: true

namespace :post_deploy do
  puts 'Running post deploy'

  system './bin/openssh_install'
end
