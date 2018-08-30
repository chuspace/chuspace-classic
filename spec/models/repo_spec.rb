# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repo, type: :model do
  let!(:user) { create(:user) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to belong_to(:user) }
end
