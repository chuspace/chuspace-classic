# frozen_string_literal: true

FactoryBot.define do
  factory :user_relationship do
    follower { nil }
    followed { nil }
  end
end
