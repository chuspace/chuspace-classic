FactoryBot.define do
  factory :post do
    title { Faker::Lorem.sentence }
    summary { Faker::Lorem.sentence }
    association :author, factory: :user, strategy: :build
    publication
    unlisted { false }
  end
end
