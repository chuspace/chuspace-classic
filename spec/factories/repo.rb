# frozen_string_literal: true

FactoryBot.define do
  factory :repo do |f|
    f.sequence(:name) { |n| "Repo #{n}" }
    description 'Foo bar'
    user
  end
end
