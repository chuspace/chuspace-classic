# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bookmark, type: :model do
  it { is_expected.to belong_to(:owner) }
  it { is_expected.to belong_to(:post) }
end
