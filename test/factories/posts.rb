# typed: ignore
# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    title { Faker::Lorem.sentence }
    summary { Faker::Lorem.sentence }
    association :author, factory: :user, strategy: :create
    publication
    unlisted { false }

    after(:create) do |post, evaluator|
      post.publication.repository.create_blob(path: post.blob_path, content: Faker::Markdown.sandwich(sentences: 5))
    end
  end
end
