# frozen_string_literal: true

FactoryBot.define do
  factory :reaction do
    text { 'MyText' }
    author { nil }
    comment { nil }
  end
end
