# typed: false
# frozen_string_literal: true

class RunGitGcJob < ApplicationJob
  queue_as :default

  def perform
    Publication.includes(:owner).find_each do |publication|
      repository = publication.repository
      last_committed_at = repository.commit.epoch_time
      last_check = 23.hours.ago.to_i

      next if last_committed_at < last_check

      Rails.logger.info "Running git gc on #{repository.path}"
      "cd #{repository.path} && git gc --aggressive"
    end
  end
end
