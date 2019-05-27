# frozen_string_literal: true

class PostReceiveJob < ApplicationJob
  queue_as :default

  def perform(*args)
    old_sha, new_sha, ref, repo_name, user_id = args

    blog = Blog.find_by(repo_name: repo_name)
    rugged_commit = blog.repo.lookup(new_sha)
    diff = Git::Commit.diff_from_parent(rugged_commit)

    diff.deltas.each do |delta|
      case delta.status
      when :added
        Post.create_from_blob(blog: blog, blob_id: delta.new_file[:oid])
      when :renamed, :modified
        Post.update_from_blob(blog: blog, old_blob_id: delta.old_file[:oid], new_blob_id: delta.new_file[:oid])
      when :deleted
        Post.destroy_from_blob(blog: blog, blob_id: delta.old_file[:oid])
      end
    end
  end
end
