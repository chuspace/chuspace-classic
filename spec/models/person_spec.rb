# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Person, type: :model do
  subject { create(:person) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:nickname) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  it { is_expected.to validate_uniqueness_of(:nickname).case_insensitive }

  it { is_expected.to have_many(:posts) }
end
