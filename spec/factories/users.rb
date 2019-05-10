# frozen_string_literal: true

FactoryBot.define do
  factory :user, aliases: %i[author committer] do |f|
    f.sequence(:name) { |n| "Test Foo bar #{n}" }
    f.sequence(:email) { |n| "test-foo#{n}@chuspace.com" }
    f.sequence(:nickname) { |n| "test-foo#{n}" }
    auth_token { SecureRandom.hex(11) }

    after(:build) { |user| user.default_blog ||= FactoryBot.build(:blog, author: user) }

    bio { 'Developer' }
    company { 'Chuspace' }
    blog_storage_path { Git.config.storage_path }
  end
end
