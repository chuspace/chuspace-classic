# frozen_string_literal: true

FactoryBot.define do
  factory :tag_relationship do
    follower { nil }
    followed { nil }
  end
end
