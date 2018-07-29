# frozen_string_literal: true

module Git
  class CreateAndStoreRepo
    include Service

    attr_reader :repo, :user

    def initialize(user:, repo:)
      @user = user
      @repo = repo
    end

    def call
      return unless repo.nil?
      create_git_repo
      repo.update!(git_repo: user_repo_dir)
    end

    private

    def create_git_repo
      Rugged::Repository.init_at(user_repo_dir.to_s, :bare)
    end
    
    def user_repo_dir
      @git_dir ||= Pathname.new('/volumes/git').join(user.id, repo.id).tap(&:mkpath)
    end
  end
end
