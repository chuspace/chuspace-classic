# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    title 'MyString'
    slug 'MyString'
    body 'MyText'
    user_id ''
    repo_id ''
    tags 'MyString'
    state false
    published_at ''
  end
  factory :repo do
    name 'MyString'
    github_id 'MyString'
    description 'MyString'
  end
  factory :user do

  end
  factory :account do
    name 'MyString'
    timezone 'MyString'
    country 'MyString'
  end
end
