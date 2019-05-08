# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject { create(:user, name: 'Foo Bar') }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:nickname) }
  it { is_expected.to validate_uniqueness_of(:email) }
  it { is_expected.to validate_uniqueness_of(:nickname).case_insensitive }
  it { is_expected.to have_many(:ssh_keys) }
  it { is_expected.to have_many(:blogs) }

  it 'should have initials' do
    expect(subject.initials).to eq('FB')
  end
end
