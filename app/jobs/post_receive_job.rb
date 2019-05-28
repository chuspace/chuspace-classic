# frozen_string_literal: true

class PostReceiveJob
  include Sidekiq::Worker
  sidekiq_options queue: 'critical'

  def perform(*args)
    old_sha, new_sha, ref, user_id = args

    author = User.find(user_id)
    rugged_commit = author.repo.lookup(new_sha)
    diff = Git::Commit.diff_from_parent(rugged_commit)

    diff.deltas.each do |delta|
      case delta.status
      when :added, :modified
        Post.create_from_blob(author: author, blob_id: delta.new_file[:oid])
      when :renamed
        Post.update_from_blob(author: author, old_blob_id: delta.old_file[:oid], new_blob_id: delta.new_file[:oid])
      when :deleted
        Post.destroy_from_blob(author: author, blob_id: delta.old_file[:oid])
      end
    end
  end
end
