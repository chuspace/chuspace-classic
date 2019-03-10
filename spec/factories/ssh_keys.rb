# frozen_string_literal: true

FactoryBot.define do
  factory :ssh_key do
    title { 'MyString' }
    key { 'MyText' }
    person { nil }
  end
end
