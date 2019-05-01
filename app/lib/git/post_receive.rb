module Git
  class PostReceive
    attr_reader :repository, :repo_path, :changes, :jid
    delegate :config, to: Git

    def initialize(repository, repo_path, actor, changes)
      @repository = repository
      @repo_path, @actor = repo_path.strip, actor
      @changes = changes
      @jid = SecureRandom.hex(12)
    end

    def exec
      $stderr.puts 'i run'
      # do something here after receive
    end
  end
end
