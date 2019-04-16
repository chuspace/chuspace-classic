# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reaction, type: :model do
  it { is_expected.to belong_to(:comment) }
  it { is_expected.to belong_to(:author) }
end
