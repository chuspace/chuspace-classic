# frozen_string_literal: true

namespace :chuspace do
  task :setup do
    desc 'Post deployment tasks'
    GLOBAL_HOOKS_DIRECTORY =
      Rails.env.production? ? '/home/git/chuspace.com/mobius/git-hooks' : Rails.root.join('bin', 'git-hooks')
    MOBIUS_DEST = Rails.env.production? ? '/home/git/chuspace.com/mobius' : Rails.root.join('bin')
    MOBIUS_ROOT = Rails.root.join('extensions', 'mobius')
    MOBIUS_SRC = MOBIUS_ROOT.join('src')
    MOBIUS_BINARIES = %w[mobius/hooks/pre_receive mobius/hooks/post_receive mobius]

    FileUtils.mkdir_p(GLOBAL_HOOKS_DIRECTORY)

    MOBIUS_BINARIES.each do |binary|
      binary_src_path = MOBIUS_SRC.join("#{binary}.cr")
      binary_name = File.basename(binary).dasherize

      system(
        ENV,
        "cd #{MOBIUS_ROOT} && shards install && crystal build #{binary_src_path} --release -p --no-debug -o #{
          binary_name
        }"
      )

      binary_path = MOBIUS_ROOT.join(binary_name)

      if binary.include?('hooks')
        FileUtils.mv(binary_path, GLOBAL_HOOKS_DIRECTORY)
      else
        FileUtils.mv(binary_path, MOBIUS_DEST.join(binary_name))
      end

      system "cd #{Rails.root}"
    end

    puts "Compiled mobius binaries to #{MOBIUS_DEST}"
  end
end
