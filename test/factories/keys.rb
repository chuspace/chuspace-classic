FactoryBot.define do
  factory :key do
    title { 'Mac' }
    key { SSHKey.generate.ssh_public_key }
    user
    last_used { Time.now }
    fingerprint { SSHKey.fingerprint(SSHKey.generate.ssh_public_key) }
  end
end
