# frozen_string_literal: true

module Posts::Github
  extend ActiveSupport::Concern

  def commit_to_github
    user.github_client.create_contents(repo.github_repo_full_name, "#{slug}.md", commit, body)
  end
end
