# frozen_string_literal: true

class PostReceiveJob
  include Sidekiq::Worker
  sidekiq_options queue: 'critical'

  def perform(*args)
    old_sha, new_sha, ref, user_id = args
    Post.sync_from_repo(old_sha: old_sha, new_sha: new_sha, ref: ref, user_id: user_id)
  end
end
