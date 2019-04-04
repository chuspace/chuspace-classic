# frozen_string_literal: true

FactoryBot.define do
  factory :person do |f|
    f.sequence(:name) { |n| "Test Foo bar #{n}" }
    f.sequence(:email) { |n| "test-foo#{n}@chuspace.com" }
    f.sequence(:nickname) { |n| "test-foo#{n}" }
    auth_token { SecureRandom.hex(11) }

    bio { 'Developer' }
    company { 'Chuspace' }
  end
end
