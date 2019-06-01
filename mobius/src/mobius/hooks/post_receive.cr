require "sidekiq"

module Mobius
  module Hooks
    class PostReceive
      JOB_CLASS = "PostReceiveJob"
      QUEUE = "critical"
      DEFAULT_REF = "refs/heads/master"

      def self.exec
        _, new_sha, ref = STDIN.gets_to_end.split(" ", remove_empty: true)
        exit unless ref == DEFAULT_REF

        args = [] of String
        args << ENV.fetch("GIT_USER_ID", "")
        args << ENV.fetch("GIT_REPO_NAME", "")
        args << new_sha

        Sidekiq::Client.default_context = Sidekiq::Client::Context.new
        job = Sidekiq::Job.new
        job.klass = JOB_CLASS
        job.queue = QUEUE
        job.args = args.to_json

        client = Sidekiq::Client.new
        client.push(job)
      end
    end
  end
end

Mobius::Hooks::PostReceive.exec
