# typed: ignore
# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.unique.name }
    email { Faker::Internet.unique.email }
    nickname { Faker::Internet.unique.username(separators: %w[-]) }
    avatar { StringIO.new(Rails.root.join('test', 'fixtures', 'files', 'avatar.jpeg').read) }
  end
end
