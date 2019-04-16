# frozen_string_literal: true

FactoryBot.define do
  factory :blog do
    title { 'MyString' }
    slug { 'MyString' }
    introduction { 'MyText' }
    author { nil }
    status { 1 }
    premium { false }
    version { 'MyString' }
    repo_name { 'MyString' }
    repo_path { 'MyString' }
    commit_sha { 'MyString' }
  end
end
