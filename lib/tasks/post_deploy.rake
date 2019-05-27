# frozen_string_literal: true

namespace :chuspace do
  namespace :post_deploy do
    MOBIUS_ROOT = Rails.root.join('mobius')
    MOBIUS_SRC = MOBIUS_ROOT.join('src')
    MOBIUS_BIN = MOBIUS_ROOT.join('bin')
    MOBIUS_BINARIES = %w[mobius/hooks/pre_receive mobius/hooks/post_receive mobius]

    FileUtils.mkdir_p(MOBIUS_BIN)
    puts 'Installing openssh server'
    system './bin/openssh_install'

    puts 'Compiling mobius binaries'
    MOBIUS_BINARIES.each do |binary|
      binary_src_path = MOBIUS_SRC.join("#{binary}.cr")
      binary_name = FasterPath.basename(binary).dasherize

      system "cd #{MOBIUS_ROOT} && crystal build #{binary_src_path} --release -p -t -s --no-debug -o #{binary_name}"
      binary_path = MOBIUS_ROOT.join(binary_name)

      FileUtils.mv(binary_path.to_s, MOBIUS_BIN.join(binary_name).to_s)
      system "cd #{ Rails.root}"
    end
  end
end
