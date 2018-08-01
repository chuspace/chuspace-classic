require 'rails_helper'

RSpec.describe Git::CreateAndStoreRepo do
  let(:user) { create(:user) }

  before do
    described_class.call(user: user)
    user.repo.reload
  end

  it 'should have a persistent repo that can be interacted with' do
    expect(Rugged::Repository.new(user.repo.git_repo)).to be_empty
  end
end
