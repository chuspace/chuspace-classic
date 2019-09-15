# typed: false
# frozen_string_literal: true

class CreateRepositoryJob < ApplicationJob
  queue_as :default

  def perform(args)
    owner = User.find(args[:author_id].to_i)
    Repository.new(name: args[:name], path: args[:path], author: owner)&.create
  end
end
