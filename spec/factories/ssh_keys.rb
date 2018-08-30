# frozen_string_literal: true

FactoryBot.define do
  factory :ssh_key do
    user nil
    name 'MyString'
    key 'MyText'
  end
end
