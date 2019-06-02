require "./common.cr"

module Mobius
  module Hooks
    class PostReceive
      include Mobius::Hooks::Common
      POST_RECEIVE_CHECK_ENDPOINT= "/mobius/post_receive"

      getter commit_sha : String

      def initialize
        _, @commit_sha, ref = STDIN.gets_to_end.split(" ", remove_empty: true)
        exit 0 unless ref.try &.strip == DEFAULT_REF
      end

      def exec
        repo_id = ENV.fetch("GIT_REPO_ID", "")
        user_id = ENV.fetch("GIT_USER_ID", "")

        HTTP::Client.post(
          "#{base_url}#{POST_RECEIVE_CHECK_ENDPOINT}",
          headers: HTTP_HEADERS,
          form: {
            "token" => token,
            "repository_id" => repo_id,
            "author_id" => user_id,
            "commit_sha" => commit_sha
          }
        )
      end
    end
  end
end

Mobius::Hooks::PostReceive.new.exec
