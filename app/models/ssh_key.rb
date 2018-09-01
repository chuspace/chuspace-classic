# frozen_string_literal: true

class SshKey < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :key, presence: true, uniqueness: { case_sensitive: false }

  validate :public_ssh_key_type
  validate :public_ssh_key

  private

  def public_ssh_key_type
    errors.add(:key, :invalid_ssh_key_type) unless key&.starts_with?(*SSHKey::SSH_TYPES.keys)
  end

  def public_ssh_key
    errors.add(:key, :invalid_ssh_key) unless SSHKey.valid_ssh_public_key?(key)
  end
end
