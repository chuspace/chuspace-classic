require 'rails_helper'

RSpec.describe Blog, type: :model do
  it { is_expected.to belong_to(:author) }
end
