# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    text { 'MyText' }
    author { nil }
    post { nil }
    reactions_count { '' }
  end
end
