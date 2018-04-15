# frozen_string_literal: true

class RepoForm
  attr_reader :user

  def initialize(user_id)
    @user = User.find(user_id)
  end

  def id
    "repo_form_#{user.id}".freeze
  end

  def owner
    Rails.cache.fetch(id) do
      [user.github_profile.login, *organizations.map(&:login)]
    end
  end

  private
    def organizations
      user.github_client.organizations
    end
end
