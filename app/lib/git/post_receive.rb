require 'securerandom'
require_relative 'repository'

module Git
  class PostReceive
    attr_reader :repository, :repo_name, :repo_path, :changes, :jid

    def initialize(repo_path, repo_name, key_id, changes)
      @repo_path = repo_path.strip
      @repository = Git::Repository.new(path: repo_path)
      @changes = changes
      @repo_name = repo_name
      @jid = SecureRandom.hex(12)
    end

    def exec
      $stderr.puts 'i run'
      true
      # do something here after receive
    end
  end
end
