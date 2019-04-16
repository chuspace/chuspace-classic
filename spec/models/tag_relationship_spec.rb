# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TagRelationship, type: :model do
  it { is_expected.to belong_to(:follower) }
  it { is_expected.to belong_to(:tag) }
end
