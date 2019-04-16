FactoryBot.define do
  factory :contribution do
    contributor { nil }
    post { nil }
    raw_content { "MyText" }
    status { 1 }
  end
end
