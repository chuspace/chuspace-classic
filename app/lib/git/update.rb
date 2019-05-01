module Git
  class Update
    attr_reader :repository, :repo_path, :key_id, :protocol
    delegate :config, to: Git

    def initialize(repo_path, key_id)
      @repo_path = repo_path.strip
      @repository = Git::Repository.new(path: @repo_path)
      @key_id = key_id
      @jid = SecureRandom.hex(12)
    end

    def update(ref_name, old_value, new_value)
      # do something here before receive
    end
  end
end
