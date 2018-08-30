# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SshKey, type: :model do
  it { is_expected.to belong_to(:user) }

  describe 'with a valid key and type' do
    subject { create(:ssh_key) }

    it { is_expected.to be_valid }
  end

  describe 'with an invalid key type' do
    key_without_type = SSHKey.generate.ssh_public_key.tr('ssh-rsa', '')
    subject { build(:ssh_key, key: key_without_type) }

    it { is_expected.to be_invalid }
  end

  describe 'with a valid type but invalid key' do
    subject { build(:ssh_key, key: 'ssh-rsa foo') }

    it { is_expected.to be_invalid }
  end
end
