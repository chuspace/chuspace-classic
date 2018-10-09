# frozen_string_literal: true

FactoryBot.define do
  factory :blog do
    name { 'MyString' }
    slug { '' }
    person { nil }
  end
end
