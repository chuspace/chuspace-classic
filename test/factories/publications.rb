FactoryBot.define do
  factory :publication do
    name { Faker::Name.unique.name }
    description { Faker::Company.catch_phrase }
    twitter { 'https://twitter.com/chuspace' }
    website { 'https://chuspace.com' }
    topics { Faker::Lorem.words }
    association :owner, factory: :user, strategy: :build
    avatar_remote_url { Faker::Avatar.image }
  end
end
