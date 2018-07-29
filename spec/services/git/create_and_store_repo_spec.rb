require 'rails_helper'

RSpec.describe Git::CreateAndStoreRepo do
  let(:user) { create(:user) }
  subject { described_class.call(user: user) }

  it 'should create a bare git repo in a temporary location' do
    expect(subject.repo).to be_nil
  end

  it 'should attach that repo to the user' do
    expect(subject.user.repo).to be_attached
  end
end
