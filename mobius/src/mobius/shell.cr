
module Mobius
  class Shell
    class RepositoryNotFound < Exception; end

    GIT_COMMANDS = %w(git-upload-pack git-receive-pack git-upload-archive)
    BINARY = "/etc/chuspace/mobius shell"
    GIT_PROTOCOL = "ssh"

    def self.call(user : String)
      unless fetchEnv("SSH_CONNECTION")
        STDERR.puts "ERROR: Only ssh allowed"
        exit 1
      end

      original_cmd = ENV.delete("SSH_ORIGINAL_COMMAND")
      commands = original_cmd.try &.split(" ", remove_empty: true)
      command = commands.try &.[0] || ""

      unless commands.try &.size == 2 && GIT_COMMANDS.try &.includes?(command)
        STDERR.puts "ERROR: Sorry! we don't recognise the command you are trying to run."
        exit 1
      end

      begin
        _, user_id = user.split("-")
        repo_name = commands.try &.[1].try &.gsub("'", "").try &.lstrip("/")

        sql = <<-STRING
          SELECT id, name, path
          FROM repositories
          WHERE author_id = $1 AND name = $2
          LIMIT 1
        STRING

        repo_id, name, path = Mobius.database.query_one sql, user_id, repo_name, as: { Int64, String, String }

        raise RepositoryNotFound.new("Repository not found") if name.nil?
        raise RepositoryNotFound.new("Repository not found") unless path && Dir.exists?(path)

        Process.exec(command, { path }, {
          "HOME" => fetchEnv("HOME"),
          "PATH" => fetchEnv("PATH"),
          "LD_LIBRARY_PATH" => fetchEnv("LD_LIBRARY_PATH"),
          "LANG" => fetchEnv("LANG"),
          "GIT_USER_ID" => user_id.to_s,
          "GIT_REPO_ID" => repo_id.to_s,
          "GIT_REPO_NAME" => name,
          "GIT_PROTOCOL" => GIT_PROTOCOL
        })

      rescue PQ::PQError
        STDERR.puts "ERROR: Something went wrong!"
      rescue DB::Error
        STDERR.puts "ERROR: Repository not found #{repo_name}"
      rescue RepositoryNotFound
        STDERR.puts "ERROR: We couldn't locate your repository #{repo_name}"
      ensure
        Mobius.database.close
      end
    end

    private def self.fetchEnv(key : String)
      ENV.fetch(key, nil)
    end
  end
end
