# typed: true
# frozen_string_literal: true

class Posts::Publish
  def self.policy_name
    'Posts::PublishPolicy'
  end
end
