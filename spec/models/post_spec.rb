require 'rails_helper'

RSpec.describe Post, type: :model do
  subject { create(:post) }

  it { should belong_to(:user) }
  it { should belong_to(:repo) }
end
