# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Git::CreateAndStoreRepo do
  let(:user) { create(:user) }
  it 'should have a persistent repo that can be interacted with'
end
