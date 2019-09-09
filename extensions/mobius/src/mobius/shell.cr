
module Mobius
  class Shell
    class RepositoryNotFound < Exception; end

    GIT_COMMANDS = %w(git-upload-pack git-receive-pack git-upload-archive)
    BINARY = "/etc/git/mobius shell"
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
          SELECT
            "publications"."id",
            "publications"."repo_name",
            "publications"."repo_path"
          FROM
            "publications"
            INNER JOIN "collaborators" ON "collaborators"."publication_id" = "publications"."id"
          WHERE
            "publications"."repo_name" = $1
            AND "collaborators"."user_id" = $2
          LIMIT 1
        STRING

        publication_id, repo_name, repo_path = Mobius.database.query_one sql, repo_name, user_id, as: { Int64, String, String }

        raise RepositoryNotFound.new("Repository not found") if repo_name.nil?
        raise RepositoryNotFound.new("Repository not found") unless repo_path && Dir.exists?(repo_path)

        Process.exec(command, { repo_path }, {
          "HOME" => fetchEnv("HOME"),
          "PATH" => fetchEnv("PATH"),
          "LD_LIBRARY_PATH" => fetchEnv("LD_LIBRARY_PATH"),
          "LANG" => fetchEnv("LANG"),
          "GIT_USER_ID" => user_id.to_s,
          "GIT_PUBLICATION_ID" => publication_id.to_s,
          "GIT_REPO_NAME" => repo_name,
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
