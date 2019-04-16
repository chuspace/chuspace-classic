# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    title { 'MyString' }
    excerpt { 'MyText' }
    body { 'MyText' }
    author { nil }
    published_at { '2019-04-16 12:48:47' }
    status { 1 }
    premium { false }
  end
end
