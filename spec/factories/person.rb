# frozen_string_literal: true

FactoryBot.define do
  factory :person do |f|
    f.sequence(:name) { |n| "Foo bar #{n}" }
    f.sequence(:email) { |n| "foo#{n}@chuspace.com" }
    f.sequence(:nickname) { |n| "foo#{n}" }
    auth_token { SecureRandom.hex(11) }

    bio { 'Developer' }
    company { 'Chuspace' }
  end
end
