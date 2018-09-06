# frozen_string_literal: true

module Git
  class CreateRepo
    include Service
    attr_reader :user

    def initialize(user:)
      @user = user
    end

    def call
      # TODO
    end
  end
end
