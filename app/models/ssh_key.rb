# frozen_string_literal: true

class SshKey < ApplicationRecord
  belongs_to :user

  validates_presence_of :title, :fingerprint
  validates :key, presence: true, uniqueness: { message: :nonunique_key }
  validate :ssh_key_format, on: :create

  before_validation :assign_fingerprint
  after_create :write_key_to_auth_file, unless: :command_exists_in_file?
  before_destroy :remove_key_from_auth_file

  def key_id
    "key-#{id}"
  end

  def command
    "#{Rails.root}/bin/#{Git::Shell::BINARY} #{key_id}"
  end

  def command_with_key
    "command=\"#{command}\",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty #{key}"
  end

  def command_exists_in_file?
    open_auth_file('r+') { |f| f.grep(/command=\"#{command}\"/).size > 0 }
  end

  private

  def assign_fingerprint
    if key && SSHKey.valid_ssh_public_key?(key)
      self.fingerprint = SSHKey.fingerprint(key)
    end
  end

  def ssh_key_format
    errors.add(:key, :invalid_key) unless SSHKey.valid_ssh_public_key?(key)
  end

  def write_key_to_auth_file
    lock do
      Rails.logger.info "Adding key #{id} => #{key}"
      open_auth_file('a') { |file| file.puts(command_with_key) }
    end
    true
  end

  def remove_key_from_auth_file
    lock do
      Rails.logger.info "Removing key #{id}"
      open_auth_file('r+') do |f|
        while line = f.gets
          next unless line.start_with?("command=\"#{command}\"")
          f.seek(-line.length, IO::SEEK_CUR)
          f.write('#' * (line.length - 1))
        end
      end
    end
    true
  end

  def lock(timeout = 10)
    File.open(Git.config.ssh_auth_lock_file_path, 'w+') do |f|
      begin
        f.flock File::LOCK_EX
        Timeout.timeout(timeout) { yield }
      ensure
        f.flock File::LOCK_UN
      end
    end
  end

  def open_auth_file(mode)
    open(Git.config.ssh_auth_file_path, mode, 0o600) do |file|
      file.chmod(0o600)
      yield file
    end
  end
end
