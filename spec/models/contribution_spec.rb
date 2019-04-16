require 'rails_helper'

RSpec.describe Contribution, type: :model do
  it { is_expected.to belong_to(:post) }
  it { is_expected.to belong_to(:contributor) }
end
