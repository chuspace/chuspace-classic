# frozen_string_literal: true

class SshKey < ApplicationRecord
  belongs_to :user

  validates_presence_of :title, :fingerprint
  validates :key, presence: true, uniqueness: { message: :nonunique_key }
  validate :ssh_key_format, on: :create

  before_validation :assign_fingerprint

  def key_id
    "key-#{id}"
  end

  def command
    "#{Rails.root}/bin/#{Git::Shell::BINARY} #{key_id}"
  end

  def command_with_key
    "command=\"#{command}\",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty #{key}"
  end

  private

  def assign_fingerprint
    self.fingerprint = SSHKey.fingerprint(key) if key && SSHKey.valid_ssh_public_key?(key)
  end

  def ssh_key_format
    errors.add(:key, :invalid_key) unless SSHKey.valid_ssh_public_key?(key)
  end
end
