# frozen_string_literal: true

FactoryBot.define do
  factory :user do |f|
    f.sequence(:name) { |n| "Foo bar #{n}" }
    f.sequence(:email) { |n| "foo#{n}@chuspace.com" }
    f.sequence(:nickname) { |n| "foo#{n}" }
    auth_token { SecureRandom.hex(11) }
    bio 'Developer'
    company 'Chuspace'
    github_nickname 'MyString'
    f.sequence(:github_uid) { |n| SecureRandom.random_number(10000000) * n }
    github_access_token 'MyString'
  end
end
