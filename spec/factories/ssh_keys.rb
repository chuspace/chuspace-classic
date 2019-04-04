# frozen_string_literal: true

FactoryBot.define do
  factory :ssh_key do
    title { 'MyString' }
    key { SSHKey.generate.ssh_public_key }

    person
  end
end
