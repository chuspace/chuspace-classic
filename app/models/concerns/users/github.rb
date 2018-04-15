# frozen_string_literal: true

module Users
  module Github
    extend ActiveSupport::Concern

    def github_orgs
      Rails.cache.fetch(id) do
        [github_profile.login, *organizations.map(&:login)]
      end
    end

    def github_client
      @github_client ||= ::Github.new(github_access_token).client
    end

    def github_profile
      @github_profile ||= github_client&.user
    end

    def github_repo
      @github_repo ||= github_client&.repo(github_repo_id)
    end

    private
      def organizations
        github_client.organizations
      end
  end
end
