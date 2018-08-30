# frozen_string_literal: true

FactoryBot.define do
  factory :post do |f|
    f.sequence(:title) { |n| "Welcome to Chuspace #{n}" }
    body { 'Welcome to Chuspace blogging' }
    user
    f.sequence(:commit) { |n| 'commit #{n}' }
    f.sequence(:version) { |n| n }
    tags { ['foo', 'bar'] }
    state { false }
    published_at { Time.now }
  end
end
