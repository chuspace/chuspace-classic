require "sidekiq"

module Mobius
  module Hooks
    class PostReceive
      JOB_CLASS = "PostReceiveJob"
      QUEUE = "critical"

      getter user_id : String
      property refs : Array(String)

      def initialize
        @user_id = ENV.fetch("USER_ID", "")
        @refs = STDIN.gets_to_end.split(" ", remove_empty: true)
      end

      def exec
        @refs << user_id

        Sidekiq::Client.default_context = Sidekiq::Client::Context.new
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
