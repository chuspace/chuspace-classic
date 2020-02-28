require "dotenv"
require "http/client"

Dotenv.load("/Users/gaurav/personal/chuspace/.env")

module Mobius
  module Hooks
    class PostReceive
      getter old_commit_sha : String
      getter new_commit_sha : String
      getter ref : String

      def initialize
        @old_commit_sha, @new_commit_sha, @ref = STDIN.gets_to_end.split(" ", remove_empty: true)
        exit 0 unless ref.try &.strip == "refs/heads/master"
      end

      def exec
        publication_id = ENV.fetch("GIT_PUBLICATION_ID", "")
        user_id = ENV.fetch("GIT_USER_ID", "")
        token = ENV.fetch("MOBIUS_TOKEN", "")
        base_url = ENV.fetch("CHUSPACE_URL", "")

        HTTP::Client.post(
          "#{base_url}/mobius/post_receive",
          headers: HTTP::Headers{
            "User-Agent" => "Mobius",
            "Content-Type" => "application/json"
          },
          form: {
            "token" => token,
            "publication_id" => publication_id,
            "author_id" => user_id,
            "old_commit_sha" => old_commit_sha,
            "new_commit_sha" => new_commit_sha,
            "ref" => ref
          }
        )
      end
    end
  end
end

Mobius::Hooks::PostReceive.new.exec
