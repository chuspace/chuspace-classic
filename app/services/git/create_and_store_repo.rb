# frozen_string_literal: true

module Git
  class CreateAndStoreRepo
    include Service

    attr_reader :repo, :user

    def initialize(user:)
      @user = user
    end

    def call
      return unless repo.nil?
      init_git_repo
      user.create_repo!(name: user.name, git_repo: user_repo_dir)
    end

    private

      def init_git_repo
        Rugged::Repository.init_at(user_repo_dir.to_s, :bare)
      end

      def user_repo_dir
        @user_repo_dir ||= git_storage_dir.join("#{user.id}.git").tap(&:mkpath)
      end

      def git_storage_dir
        @git_storage_dir ||= Pathname.new(ENV.fetch('GIT_STORAGE_DIR') { Dir.mktmpdir })
      end
  end
end
