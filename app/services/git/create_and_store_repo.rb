# frozen_string_literal: true

module Git
  class CreateAndStoreRepo
    include Service

    attr_reader :repo, :user

    def initialize(user:)
      @user = user
    end

    def call
      # TODO: RPC call
    end
  end
end
