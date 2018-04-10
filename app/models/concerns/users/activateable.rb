# frozen_string_literal: true

module Users
  module Activateable
    extend ActiveSupport::Concern

    included do
      include AASM

      enum state: {
        pending: 0,
        onboarding: 1,
        active: 2,
        inactive: 3
      }

      aasm column: :state, enum: true do
        state :pending, initial: true
        state :onboarding, :active
        state :onboarding, :inactive
        state :active, :inactive

        event :onboard do
          transitions from: :pending, to: :onboarding
        end

        event :activate do
          transitions from: :onboarding, to: :active
        end

        event :deactivate do
          transitions from: :onboarding, to: :inactive
          transitions from: :active, to: :inactive
        end
      end
    end
  end
end
