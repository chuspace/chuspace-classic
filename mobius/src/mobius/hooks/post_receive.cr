
require "db"
require "pg"

module Mobius
  module Hooks
    class PostReceive
      ENV["MOBIUS_ENV"] ||= "development"
      DEFAULT_DATABASE_URL = "postgres://localhost:5432/chuspace_#{ENV["MOBIUS_ENV"] }?sslmode=disable"
      JOB_CLASS = "PostReceiveJob"
      QUEUE = "critical"
      DEFAULT_REF = "refs/heads/master"

      getter new_sha : String

      def initialize
        _, @new_sha, ref = STDIN.gets_to_end.split(" ", remove_empty: true)
        exit 1 unless ref.try &.strip == DEFAULT_REF
      end

      def exec
        repo_id = ENV.fetch("GIT_REPO_ID", "")
        repo_name = ENV.fetch("GIT_REPO_NAME", "")
        user_id = ENV.fetch("GIT_USER_ID", "")

        sql = <<-STRING
          INSERT INTO commits (sha, repository_id, user_id)
          VALUES ($1, $2, $3)
        STRING

        database.exec sql, new_sha, repo_id, user_id
      rescue PQ::PQError
        STDERR.puts "ERROR: Something went wrong! #{repo_name} #{new_sha}"
      rescue DB::Error
        STDERR.puts "ERROR: Couldn't insert commit #{repo_name} #{new_sha}"
      ensure
        database.close
      end

      private def database
        DB.open ENV.fetch("DATABASE_URL", DEFAULT_DATABASE_URL)
      end
    end
  end
end

Mobius::Hooks::PostReceive.new.exec
