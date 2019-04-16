# frozen_string_literal: true

FactoryBot.define do
  factory :recommend do
    text { 'MyString' }
    post { nil }
    owner { nil }
  end
end
