# frozen_string_literal: true

namespace :chuspace do
  namespace :post_deploy do
    MOBIUS_SRC = Rails.root.join('mobius', 'src')
    MOBIUS_BINARIES = %w[hooks/pre_receive hooks/post_receive mobius]
    puts 'Running post deploy'
    system './bin/openssh_install'

    MOBIUS_BINARIES.each do
      system "crystal build src/mobius/hooks/post_receive.cr --release --no-debug -o post-receive"
    end
  end
end
