# frozen_string_literal: true

FactoryBot.define do
  factory :relationship do
    follower { nil }
    followed { nil }
  end
end
