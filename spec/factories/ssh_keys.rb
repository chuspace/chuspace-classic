# frozen_string_literal: true

FactoryBot.define do
  factory :ssh_key do
    user
    name 'My ssh key'
    key SSHKey.generate.ssh_public_key
  end
end
