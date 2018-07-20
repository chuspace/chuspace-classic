# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Repo, type: :model do
  subject { create(:repo) }

  it { should validate_presence_of(:name) }
  it { should belong_to(:user) }
end
