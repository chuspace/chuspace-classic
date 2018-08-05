# frozen_string_literal: true

module Git
  class CreateRepo
    include Service

    attr_reader :user

    def initialize(user:)
      @user = user
      @repo = user.repo
    end

    def call
      mobius.init_repo(user)
    end

    private

      def mobius
        Mobius::Client.new
      end
  end
end
