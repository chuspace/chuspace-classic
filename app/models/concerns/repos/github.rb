# frozen_string_literal: true

module Repos::Github
  extend ActiveSupport::Concern

  included do
    validates :github_repo_id, :github_repo_full_name, uniqueness: true
    after_destroy_commit :purge_github_repo!

    delegate :github_client, to: :user
  end

  def purge_github_repo!
    github_client.delete_repo(github_repo_id)
  end
end
