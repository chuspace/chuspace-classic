# typed: ignore
# frozen_string_literal: true

class SshKey < ApplicationRecord
  db_belongs_to :user

  validates_presence_of :title, :fingerprint, :key
  validates_db_uniqueness_of :key, message: :nonunique_key
  validate :ssh_key_format, on: :create

  before_validation :assign_fingerprint

  private

  def assign_fingerprint
    self.fingerprint = SSHKey.fingerprint(key) if key && SSHKey.valid_ssh_public_key?(key)
  end

  def ssh_key_format
    errors.add(:key, :invalid_key) unless SSHKey.valid_ssh_public_key?(key)
  end
end
