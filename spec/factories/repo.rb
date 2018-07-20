# frozen_string_literal: true

FactoryBot.define do
  factory :repo do |f|
    f.sequence(:name) { |n| "Repo #{n}" }
    description 'Foo bar'
    user
    github_repo_id { SecureRandom.random_number(10000000) }
    f.sequence(:github_repo_full_name) { |n| "foo/bar#{n}" }
  end
end
