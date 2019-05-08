require 'securerandom'
require_relative 'repository'

module Git
  class Update
    attr_reader :repository, :repo_name, :repo_path, :key_id, :protocol

    def initialize(repo_path, repo_name, key_id)
      @repo_path = repo_path.strip
      @repository = Git::Repository.new(path: @repo_path)
      @key_id = key_id
      @jid = SecureRandom.hex(12)
      @repo_name = repo_name
    end

    def update(ref_name, old_value, new_value)
      $stderr.puts new_value.inspect
      $stderr.puts old_value.inspect
      true
      # do something here before receive
    end
  end
end
