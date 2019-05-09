# frozen_string_literal: true

FactoryBot.define do
  factory :blog do
    name { 'MyString' }
    slug { 'MyString' }
    introduction { 'MyText' }

    author

    status { 1 }
    default { false }
    repo_name { 'MyString' }
    repo_path { 'MyString' }
  end
end
