# frozen_string_literal: true

module Commitable
  extend ActiveSupport::Concern

  def commit(committer:, message:, action: :add)
    action = persisted? ? 'Updated' : 'Created'
    message ||= "#{action} post #{blob_name}"

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
