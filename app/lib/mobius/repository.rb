# frozen_string_literal: true

require 'fileutils'
require 'timeout'
require 'open3'

require_relative 'logger'
require_relative 'metrics'

module Mobius
  class Repository
    # Repository name is a directory name for repository with .git at the end
    # It may be namespaced or not. Like repo.git or mobius/repo.git
    attr_reader :repository_name

    # Absolute path to directory where repositories stored
    # By default it is /home/git/repositories
    attr_reader :repos_path

    # Full path is an absolute path to the repository
    # Ex /home/git/repositories/test.git
    attr_reader :full_path

    def initialize
      @command = ARGV.shift
      @repos_path = ARGV.shift
      @repository_name = ARGV.shift
      @full_path = File.join(@repos_path, @repository_name) unless @repository_name.nil?
    end

    def exec
      Mobius::Metrics.measure("command-#{@command}") do
        case @command
        when 'create-tag'
          create_tag
        when 'add-repository'
          add_repository
        when 'list-repositories'
          puts list_repositories
        when 'rm-repository'
          rm_repository
        when 'mv-repository'
          mv_repository
        when 'mv-storage'
          mv_storage
        when 'import-repository'
          import_repository
        when 'fork-repository'
          fork_repository
        when 'fetch-remote'
          fetch_remote
        when 'push-branches'
          push_branches
        when 'delete-remote-branches'
          delete_remote_branches
        when 'list-remote-tags'
          list_remote_tags
        when 'gc'
          gc
        else
          $logger.warn "Attempt to execute invalid mobius-repositories command #{@command.inspect}."
          puts 'not allowed'
          false
        end
      end
    end

    protected

    def list_remote_tags
      remote_name = ARGV.shift

      tag_list, exit_code, error = nil
      cmd = %W(git --git-dir=#{full_path} ls-remote --tags #{remote_name})

      Open3.popen3(*cmd) do |stdin, stdout, stderr, wait_thr|
        tag_list  = stdout.read
        error     = stderr.read
        exit_code = wait_thr.value.exitstatus
      end

      if exit_code.zero?
        puts tag_list
        true
      else
        puts error
        false
      end
    end

    def push_branches
      remote_name = ARGV.shift

      $logger.info "Pushing branches from #{full_path} to remote #{remote_name}: #{ARGV}"
      cmd = %W(git --git-dir=#{full_path} push -- #{remote_name}).concat(ARGV)
      pid = Process.spawn(*cmd)

      begin
        Process.wait(pid)

        $?.exitstatus.zero?
      rescue => exception
        $logger.error "Pushing branches to remote #{remote_name} failed due to: #{exception.message}"

        Process.kill('KILL', pid)
        Process.wait
        false
      end
    end

    def delete_remote_branches
      remote_name = ARGV.shift
      branches = ARGV.map { |branch_name| ":#{branch_name}" }

      $logger.info "Pushing deleted branches from #{full_path} to remote #{remote_name}: #{ARGV}"
      cmd = %W(git --git-dir=#{full_path} push -- #{remote_name}).concat(branches)
      pid = Process.spawn(*cmd)

      begin
        Process.wait(pid)

        $?.exitstatus.zero?
      rescue => exception
        $logger.error "Pushing deleted branches to remote #{remote_name} failed due to: #{exception.message}"

        Process.kill('KILL', pid)
        Process.wait
        false
      end
    end

    def create_tag
      tag_name = ARGV.shift
      ref = ARGV.shift || 'HEAD'
      cmd = %W(git --git-dir=#{full_path} tag)
      if ARGV.size > 0
        msg = ARGV.shift
        cmd += %W(-a -m #{msg})
      end
      cmd += %W(-- #{tag_name} #{ref})
      system(*cmd)
    end

    def add_repository
      $logger.info "Adding repository #{@repository_name} at <#{full_path}>."
      FileUtils.mkdir_p(full_path, mode: 0770)
      cmd = %W(git --git-dir=#{full_path} init --bare)
      system(*cmd)
    end

    def list_repositories
      $logger.info 'Listing repositories'
      Dir.chdir(repos_path) do
        next Dir.glob('**/*.git')
      end
    end

    def rm_repository
      $logger.info "Removing repository #{@repository_name} from <#{full_path}>."
      FileUtils.rm_rf(full_path)
    end

    def mask_password_in_url(url)
      result = URI(url)
      result.password = '*****' unless result.password.nil?
      result.user = '*****' unless result.user.nil? # it's needed for oauth access_token
      result
    rescue
      url
    end

    def fetch_remote
      @name = ARGV.shift

      # timeout for fetch
      timeout = (ARGV.shift || 120).to_i

      # fetch with --force ?
      forced = ARGV.include?('--force')

      # fetch with --tags or --no-tags
      tags_option = ARGV.include?('--no-tags') ? '--no-tags' : '--tags'

      $logger.info "Fetching remote #{@name} for repository #{@repository_name}."
      cmd = %W(git --git-dir=#{full_path} fetch #{@name})
      cmd << '--prune'
      cmd << '--force' if forced
      cmd << tags_option
      pid = Process.spawn(*cmd)

      begin
        Timeout.timeout(timeout) do
          Process.wait(pid)
        end

        $?.exitstatus.zero?
      rescue Timeout::Error
        $logger.error "Fetching remote #{@name} for repository #{@repository_name} failed due to timeout."

        Process.kill('KILL', pid)
        Process.wait
        false
      end
    end

    def remove_origin_in_repo
      cmd = %W(git --git-dir=#{full_path} remote rm origin)
      pid = Process.spawn(*cmd)
      Process.wait(pid)
    end

    # Import repository via git clone --bare
    # URL must be publicly cloneable
    def import_repository
      # Skip import if repo already exists
      return false if File.exists?(full_path)

      @source = ARGV.shift
      masked_source = mask_password_in_url(@source)

      # timeout for clone
      timeout = (ARGV.shift || 120).to_i
      $logger.info "Importing repository #{@repository_name} from <#{masked_source}> to <#{full_path}>."
      cmd = %W(git clone --bare -- #{@source} #{full_path})

      pid = Process.spawn(*cmd)

      begin
        Timeout.timeout(timeout) do
          Process.wait(pid)
        end

        return false unless $?.exitstatus.zero?
      rescue Timeout::Error
        $logger.error "Importing repository #{@repository_name} from <#{masked_source}> failed due to timeout."

        Process.kill('KILL', pid)
        Process.wait
        FileUtils.rm_rf(full_path)
        return false
      end

      # The repository was imported successfully.
      # Remove the origin URL since it may contain password.
      remove_origin_in_repo

      true
    end

    # Move repository from one directory to another
    #
    # Ex.
    #  mobius.git -> mobiushq.git
    #  mobius/mobius-ci.git -> randx/six.git
    #
    # Wont work if target namespace directory does not exist
    #
    def mv_repository
      new_path = ARGV.shift

      unless new_path
        $logger.error 'mv-repository failed: no destination path provided.'
        return false
      end

      new_full_path = File.join(repos_path, new_path)

      # verify that the source repo exists
      unless File.exists?(full_path)
        $logger.error "mv-repository failed: source path <#{full_path}> does not exist."
        return false
      end

      # ...and that the target repo does not exist
      if File.exists?(new_full_path)
        $logger.error "mv-repository failed: destination path <#{new_full_path}> already exists."
        return false
      end

      $logger.info "Moving repository #{@repository_name} from <#{full_path}> to <#{new_full_path}>."
      FileUtils.mv(full_path, new_full_path)
    end

    # Move repository from one storage path to another
    #
    # Wont work if target namespace directory does not exist in the new storage path
    #
    def mv_storage
      new_storage = ARGV.shift

      unless new_storage
        $logger.error 'mv-storage failed: no destination storage path provided.'
        return false
      end

      new_full_path = File.join(new_storage, repository_name)

      # verify that the source repo exists
      unless File.exists?(full_path)
        $logger.error "mv-storage failed: source path <#{full_path}> does not exist."
        return false
      end

      # Make sure the destination directory exists
      FileUtils.mkdir_p(new_full_path)

      # Make sure the source path ends with a slash so that rsync copies the
      # contents of the directory, as opposed to copying the directory by name
      source_path = File.join(full_path, '')

      if wait_for_pushes
        $logger.info "Syncing repository #{@repository_name} from <#{full_path}> to <#{new_full_path}>."

        # Set a low IO priority with ionice to not choke the server on moves
        if rsync(source_path, new_full_path, 'ionice -c2 -n7 rsync')
          true
        else
          # If the command fails with `ionice` (maybe because we're on a OS X
          # development machine), try again without `ionice`.
          rsync(source_path, new_full_path)
        end
      else
        $logger.error "mv-storage failed: source path <#{full_path}> is waiting for pushes to finish."
        false
      end
    end

    def gc
      $logger.info "Running git gc for <#{full_path}>."
      unless File.exists?(full_path)
        $logger.error "gc failed: destination path <#{full_path}> does not exist."
        return false
      end
      cmd = %W(git --git-dir=#{full_path} gc)
      system(*cmd)
    end

    def wait_for_pushes
      # Try for 30 seconds, polling every 10
      3.times do
        return true if reference_counter.value == 0
        sleep 10
      end

      false
    end

    def rsync(src, dest, rsync_path = 'rsync')
      command = rsync_path.split + %W(-a --delete --rsync-path="#{rsync_path}" #{src} #{dest})
      system(*command)
    end
  end
end
