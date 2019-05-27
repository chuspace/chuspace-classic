require "sidekiq"

module Mobius
  module Hooks
    class PostReceive
      JOB_CLASS = "PostReceiveJob"
      QUEUE = "critical"

      getter repo_name : String
      getter user_id : String
      property refs : Array(String)

      def initialize
        @repo_name = ENV.fetch("GIT_REPO_NAME", "")
        @user_id = ENV.fetch("USER_ID", "")
        @refs = STDIN.gets_to_end.split(" ", remove_empty: true)
      end

      def exec
        @refs << repo_name
        @refs << user_id

        job = Sidekiq::Job.new
        job.klass = JOB_CLASS
        job.queue = QUEUE
        job.args = @refs.to_json
        client = Sidekiq::Client.new
        jid = client.push(job)
      end
    end
  end
end

Mobius::Hooks::PostReceive.new.exec
