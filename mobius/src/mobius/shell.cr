
module Mobius
  class Shell
    class RepositoryNotFound < Exception; end

    GIT_COMMANDS = %w(git-upload-pack git-receive-pack git-upload-archive)
    BINARY = "/etc/chuspace/mobius shell"
    GIT_PROTOCOL = "ssh"

    def self.call(nickname : String)
      unless fetchEnv("SSH_CONNECTION")
        STDERR.puts "remote: Only ssh allowed"
        return
      end

      original_cmd = ENV.delete("SSH_ORIGINAL_COMMAND")
      commands = original_cmd.try &.split(" ", remove_empty: true)
      command = commands.try &.[0] || ""

      log_error_and_exit(nickname) unless GIT_COMMANDS.try &.includes?(command) || commands.try &.size == 2

      full_repo_name = commands.try &.[1]
      log_error_and_exit(nickname) if full_repo_name.nil?

      begin
        repo = full_repo_name.gsub("'", "").split("/", remove_empty: true)
        log_error_and_exit(nickname) unless repo.try &.size == 2

        repo_nickname = repo.try &.[0]
        repo_name = repo.try &.[1]

        raise RepositoryNotFound.new("Repository not found") unless repo_nickname && repo_nickname == nickname

        sql = <<-STRING
          SELECT author_id AS user_id, repo_path, repo_name
          FROM blogs
          INNER JOIN users ON (blogs.id = users.id)
          WHERE users.nickname = '#{nickname}' AND repo_name = '#{repo_name}'
          LIMIT 1
        STRING

        user_id, repo_path, repo_name = Mobius.database.query_one sql, as: { Int64, String, String }
        raise RepositoryNotFound.new("Repository not found") unless repo_path && Dir.exists?(repo_path)

        Process.exec(command, { repo_path }, {
          "HOME" => fetchEnv("HOME"),
          "PATH" => fetchEnv("PATH"),
          "LD_LIBRARY_PATH" => fetchEnv("LD_LIBRARY_PATH"),
          "LANG" => fetchEnv("LANG"),
          "USER_ID" => user_id.to_s,
          "USER_NICKNAME" => nickname,
          "GIT_REPO_NAME" => repo_name,
          "GIT_PROTOCOL" => GIT_PROTOCOL
        })

      rescue PQ::PQError
        STDERR.puts "remote: Something went wrong!"
      rescue DB::Error
        STDERR.puts "remote: Repository not found #{repo_name}"
      rescue RepositoryNotFound
        STDERR.puts "remote: We couldn't locate your repository #{repo_name}"
      ensure
        Mobius.database.close
      end
    end

    private def self.log_error_and_exit(username : String)
      STDERR.puts "Hey #{username}! You've successfully authenticated, but Chuspace does not provide shell access."
      exit 0
    end

    private def self.fetchEnv(key : String)
      ENV.fetch(key, nil)
    end
  end
end
