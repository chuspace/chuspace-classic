# frozen_string_literal: true

# typed: false

module Topicable
  extend ActiveSupport::Concern

  included do
    before_validation :prune_topics
    after_save :sync_topics, if: :topics_previously_changed?
    validates_length_of :topics, maximum: 5, allow_blank: true
  end

  def topics_list
    topics&.join(',')
  end

  private

  def prune_topics
    self.topics = topics.reject(&:blank?)
  end

  def sync_topics
    topics.reject(&:blank?).each { |name| Topic.find_or_create_by(name: name&.to_slug&.to_ascii&.normalize&.to_s) }
  end
end
