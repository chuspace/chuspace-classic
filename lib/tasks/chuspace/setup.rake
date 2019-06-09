# frozen_string_literal: true

namespace :chuspace do
  task :setup do
    desc 'Post deployment tasks'
    APP_BIN_DIR = Rails.root.join('bin')
    GIT_HOOKS_DIR = APP_BIN_DIR.join('git-hooks')

    MOBIUS_ROOT = Rails.root.join('mobius')
    MOBIUS_SRC = MOBIUS_ROOT.join('src')
    MOBIUS_BINARIES = %w[mobius/hooks/pre_receive mobius/hooks/post_receive mobius]
    RUST_BINARIES = %w[fast_slug fast_markdown]

    FileUtils.mkdir_p(GIT_HOOKS_DIR)

    MOBIUS_BINARIES.each do |binary|
      binary_src_path = MOBIUS_SRC.join("#{binary}.cr")
      binary_name = FasterPath.basename(binary).dasherize

      system "cd #{MOBIUS_ROOT} && crystal build #{binary_src_path} --release -p --no-debug -o #{binary_name}"
      binary_path = MOBIUS_ROOT.join(binary_name)

      if binary.include?('hooks')
        FileUtils.mv(binary_path, GIT_HOOKS_DIR)
      else
        FileUtils.mv(binary_path, APP_BIN_DIR.join(binary_name))
      end

      system "cd #{Rails.root}"
    end

    puts "Compiled mobius binaries to #{APP_BIN_DIR}"

    RUST_BINARIES.each do |binary|
      system "cd #{Rails.root}/#{binary} && bundle exec rake"
      system "cd #{Rails.root}"
    end

    puts 'Compiled rust gems'
  end
end
