# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SshKey, type: :model do
  subject { create(:ssh_key, title: 'Key 1') }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:key) }
  it { is_expected.to belong_to(:user) }

  it 'should have a title' do
    expect(subject.title).to eq('Key 1')
  end

  it 'should have a fingerprint' do
    expect(subject.fingerprint).to_not be_nil
  end

  it 'should have a key id' do
    expect(subject.key_id).to eq("key-#{subject.id}")
  end

  it 'should have a command' do
    expect(subject.command).to eq("#{Rails.root}/bin/git_shell key-#{subject.id}")
  end

  it 'should have full ssh command' do
    expect(subject.command_with_key).to eq(
      "command=\"#{Rails.root}/bin/git_shell key-#{subject
        .id}\",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty #{subject.key}"
              )
  end

  it 'should have command in file' do
    expect(subject.command_exists_in_file?).to be_truthy
  end

  it 'should have command in file' do
    subject.destroy
    expect(subject.command_exists_in_file?).to be_falsy
  end
end
