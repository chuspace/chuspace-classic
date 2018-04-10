# frozen_string_literal: true

FactoryBot.define do
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
