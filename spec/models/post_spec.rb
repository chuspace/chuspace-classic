# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  it { is_expected.to belong_to(:author) }
  it { is_expected.to have_many(:bookmarks) }
  it { is_expected.to have_many(:likes) }
  it { is_expected.to have_many(:contributions) }
  it { is_expected.to have_many(:comments) }
  it { is_expected.to have_many(:tags) }
end
