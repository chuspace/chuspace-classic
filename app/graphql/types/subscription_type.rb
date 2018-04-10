# frozen_string_literal: true

Types::SubscriptionType = GraphQL::ObjectType.define do
  name 'Subscription'
  description 'The query root of this schema for subscribing real-time data.'

  field :current_user, -> { Types::UserType }, 'Current logged in user'
end
