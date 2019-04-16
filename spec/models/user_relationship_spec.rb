# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserRelationship, type: :model do
  it { is_expected.to belong_to(:follower) }
  it { is_expected.to belong_to(:followed) }
end
