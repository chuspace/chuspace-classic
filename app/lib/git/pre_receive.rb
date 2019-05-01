module Git
  class PreReceive
    attr_reader :repo_path, :key_id, :refs, :protocol
    delegate :config, to: Git

    def initialize(repo_path, key_id, refs, protocol)
      @repo_path = repo_path.strip

      @key_id = key_id
      @refs = refs
      @protocol = protocol
    end

    def exec
      $stderr.puts 'i run'
      # do something here before receive
    end
  end
end
