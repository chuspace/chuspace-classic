# typed: ignore
# frozen_string_literal: true

FactoryBot.define do
  factory :publication do
    sequence :name do |n|
      "Chuspace#{n}"
    end

    description { 'Blogging platform for developers' }
    twitter { 'https://twitter.com/chuspace' }
    website { 'https://chuspace.com' }
    topics { %w[blogging rails] }
    association :owner, factory: :user, strategy: :build
    avatar { StringIO.new(Rails.root.join('test', 'fixtures', 'files', 'publication.jpeg').read) }
  end
end
