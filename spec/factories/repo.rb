# frozen_string_literal: true

FactoryBot.define do
  factory :repo do |f|
    f.sequence(:name) { |n| "Repo #{n}" }
    description 'Foo bar'
    url 'git@chuspace.com:chuspace/chuspace.git'
    user
  end
end
