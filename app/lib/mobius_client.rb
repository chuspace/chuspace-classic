# frozen_string_literal: true

require 'securerandom'

class MobiusClient
  class Error < StandardError; end
  STORAGE_PATH = Rails.root.join('git-storage').to_s

  KeyAdder = Struct.new(:io) do
    def add_key(id, key)
      key = MobiusClient.strip_key(key)
      # Newline and tab are part of the 'protocol' used to transmit id+key to the other end
      if key.include?("\t") || key.include?("\n")
        raise Error.new("Invalid key: #{key.inspect}")
      end

      io.puts("#{id}\t#{key}")
    end
  end

  class << self
    def strip_key(key)
      key.split(/ /)[0, 2].join(' ')
    end
  end

  # Init new repository
  #
  # name - project path with namespace
  #
  # Ex.
  #   add_repository("gitlab/gitlab-ci")
  #
  def add_repository(name)
    MobiusUtils.system_silent([mobius_shell_projects_path,
                                  'add-project', STORAGE_PATH, "#{name}.git"])
  end

  # Import repository
  #
  # name - project path with namespace
  #
  # Ex.
  #   import_repository("gitlab/gitlab-ci", "https://github.com/randx/six.git")
  #
  def import_repository(name, url)
    output, status = MobiusPopen::popen([mobius_shell_projects_path, 'import-project',
                                    STORAGE_PATH, "#{name}.git", url, '900'])
    raise Error, output unless status.zero?
    true
  end

  # Move repository
  # path - project path with namespace
  # new_path - new project path with namespace
  #
  # Ex.
  #   mv_repository("gitlab/gitlab-ci", "randx/gitlab-ci-new")
  #
  def mv_repository(path, new_path)
    MobiusUtils.system_silent([mobius_shell_projects_path, 'mv-project',
                                  STORAGE_PATH, "#{path}.git", "#{new_path}.git"])
  end

  # Remove repository from file system
  #
  # name - project path with namespace
  #
  # Ex.
  #   remove_repository("gitlab/gitlab-ci")
  #
  def remove_repository(name)
    MobiusUtils.system_silent([mobius_shell_projects_path,
                                  'rm-project', STORAGE_PATH, "#{name}.git"])
  end

  # Gc repository
  #
  # path - project path with namespace
  #
  # Ex.
  #   gc("gitlab/gitlab-ci")
  #
  def gc(path)
    MobiusUtils.system_silent([mobius_shell_projects_path, 'gc',
                                  STORAGE_PATH, "#{path}.git"])
  end

  # Add new key to gitlab-shell
  #
  # Ex.
  #   add_key("key-42", "sha-rsa ...")
  #
  def add_key(key_id, key_content)
    MobiusUtils.system_silent([mobius_shell_keys_path,
                                  'add-key', key_id, self.class.strip_key(key_content)])
  end

  # Batch-add keys to authorized_keys
  #
  # Ex.
  #   batch_add_keys { |adder| adder.add_key("key-42", "sha-rsa ...") }
  def batch_add_keys(&block)
    IO.popen(mobius_shell_keys_path, 'w') do |io|
      block.call(KeyAdder.new(io))
    end
  end

  # Remove ssh key from gitlab shell
  #
  # Ex.
  #   remove_key("key-342", "sha-rsa ...")
  #
  def remove_key(key_id, key_content)
    MobiusUtils.system_silent([mobius_shell_keys_path,
                                  'rm-key', key_id, key_content])
  end

  # Remove all ssh keys from gitlab shell
  #
  # Ex.
  #   remove_all_keys
  #
  def remove_all_keys
    MobiusUtils.system_silent([mobius_shell_keys_path, 'clear'])
  end

  # Add empty directory for storing repositories
  #
  # Ex.
  #   add_namespace(gitlab")
  #
  def add_namespace(name)
    FileUtils.mkdir(full_path(name), mode: 0770) unless exists?(name)
  end

  # Every repository inside this directory will be removed too
  #
  # Ex.
  #   rm_namespace("gitlab")
  #
  def rm_namespace(name)
    FileUtils.rm_r(full_path(name), force: true)
  end

  # Move namespace directory inside repositories storage
  #
  # Ex.
  #   mv_namespace("gitlab", "gitlabhq")
  #
  def mv_namespace(old_name, new_name)
    return false if exists?(new_name) || !exists?(old_name)

    FileUtils.mv(full_path(old_name), full_path(new_name))
  end

  def url_to_repo(path)
    Gitlab.config.mobius_shell.ssh_path_prefix + "#{path}.git"
  end

  # Return GitLab shell version
  def version
    mobius_shell_version_file = "#{mobius_shell_path}/VERSION"

    if File.readable?(mobius_shell_version_file)
      File.read(mobius_shell_version_file).chomp
    end
  end

  # Check if such directory exists in repositories.
  #
  # Usage:
  #   exists?('gitlab/cookies.git')
  #
  def exists?(dir_name)
    File.exist?(full_path(dir_name))
  end

  # Create (if necessary) and link the secret token file
  def generate_and_link_secret_token
    secret_file = Gitlab.config.mobius_shell.secret_file
    unless File.size?(secret_file)
      # Generate a new token of 16 random hexadecimal characters and store it in secret_file.
      token = SecureRandom.hex(16)
      File.write(secret_file, token)
    end

    link_path = File.join(mobius_shell_path, '.mobius_shell_secret')
    if File.exist?(mobius_shell_path) && !File.exist?(link_path)
      FileUtils.symlink(secret_file, link_path)
    end
  end

  protected

  def mobius_shell_path
    Rails.root
  end

  def mobius_shell_user_home
    File.expand_path("~#{Gitlab.config.mobius_shell.ssh_user}")
  end

  def full_path(dir_name)
    raise ArgumentError.new("Directory name can't be blank") if dir_name.blank?

    File.join(STORAGE_PATH, dir_name)
  end

  def mobius_shell_projects_path
    mobius_shell_path.join('bin', 'mobius_projects').to_s
  end

  def mobius_shell_keys_path
    mobius_shell_path.join('bin', 'mobius_keys').to_s
  end
end
