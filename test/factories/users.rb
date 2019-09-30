# typed: ignore
# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.unique.first_name }
    last_name { Faker::Name.unique.last_name }
    email { Faker::Internet.unique.email }
    nickname { Faker::Internet.unique.username(separators: %w[-]) }
    avatar { StringIO.new(Rails.root.join('test', 'fixtures', 'files', 'avatar.jpeg').read) }
    bio { 'Lorem ipsum' }
    company { 'chuspace' }
    location { 'Earth' }
    auth_token { SecureRandom.hex }
    url { 'https://chuspace.com' }
  end
end
