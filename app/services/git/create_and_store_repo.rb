# frozen_string_literal: true

module Git
  class CreateAndStoreRepo
    includes Service

    attr_reader :repo

    def initialize(user:)
      @user = user
    end

    def call
      init_repo
      push_to_bucket
    end

    private

    def init_repo
      return unless repo.nil?
      
      Dir.mktmpdir(['chuspace-git', user.id]) do |temp_dir|
        @repo ||= Rugged::Repository.init_at(temp_dir, :bare)
      end
    end

    def push_to_bucket
      user.repo.attach(repo)
    end
  end
end
