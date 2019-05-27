# frozen_string_literal: true

module Commitable
  extend ActiveSupport::Concern

  class_methods do
    def commit_and_create_by(blog:, committer:, attrs:, commit_message: nil)
      post = blog.posts.find_or_initialize_by(attrs)
      post.commit_and_save(committer: committer, commit_message: commit_message)
    end
  end

  def commit_and_save(committer:, commit_message: nil)
    if valid?
      action = persisted? ? 'Updated' : 'Created'
      commit_message ||= "#{action} post #{blob_name}"
      blob = commit(committer: committer, message: commit_message)

      self.blob_id = blob.id
      self.save
    end

    self
  end

  def commit_and_destroy(committer:, commit_message: nil)
    if destroy
      commit_message ||= "Deleted post #{blob_name}"
      commit(committer: committer, message: commit_message, action: :remove)
    end

    self
  end

  private

  def commit(committer:, message:, action: :add)
    Git::Commit.create(
      repository: repo,
      committer: committer,
      action: action,
      options: {
        commit: { message: message || "Created post #{blob_name}" }, file: { content: blob_content, path: blob_name }
      }
    )
  end
end
