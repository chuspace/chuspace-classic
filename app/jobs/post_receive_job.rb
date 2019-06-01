# frozen_string_literal: true

class PostReceiveJob
  include Sidekiq::Worker
  sidekiq_options queue: 'critical'

  def perform(*args)
    user_id, repo_name, new_sha = args
    Post.sync_from_repo(new_sha: new_sha, repo_name: repo_name, user_id: user_id)
  end
end
