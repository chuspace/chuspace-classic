# frozen_string_literal: true

class SshKey < ApplicationRecord
  belongs_to :person

  validates_presence_of :title
  validates :key, presence: true, uniqueness: { message: :nonunique_key }
  validate :ssh_key_format
  before_create :assign_fingerprint

  private

  def assign_fingerprint
    self.fingerprint = SSHKey.fingerprint(key)
  end

  def ssh_key_format
    errors.add(:key, :invalid_key) unless SSHKey.valid_ssh_public_key?(key)
  end
end
