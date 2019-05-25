# frozen_string_literal: true

require 'forwardable'
require 'rugged'
require_relative 'logger'
require_relative 'blob'

module Git
  class Repository
    extend Forwardable

    class NoRepository < StandardError; end
    class InvalidBlobName < StandardError; end
    class InvalidRef < StandardError; end
    class InvalidAuthor < StandardError; end

    START_REF = 'HEAD'
    DEFAULT_REF = 'refs/heads/master'
    CONTRIBUTIONS_REF = 'refs/heads/contributions'
    GLOBAL_HOOKS_DIRECTORY = File.join(Git::Config::ROOT_PATH, 'hooks')

    attr_reader :name, :path, :rugged

    def_delegators :@rugged, :lookup, :checkout, :empty?, :bare?, :index

    def initialize(path:)
      @name = path.split('/').last
      @path = path
    end

    def reload
      @rugged = nil
    end

    def size
      size = popen(%w[du -sk], path).first.strip.to_i
      (size.to_f / 1_024).round(2)
    end

    def rugged
      @rugged ||= Rugged::Repository.bare(path)
    rescue Rugged::RepositoryError, Rugged::OSError
      fail NoRepository, 'no repository for such path'
    end

    def exists?
      !!rugged
    end

    def root_branch
      @root_branch ||= discover_default_branch
    end

    def head
      rugged.head
    rescue Rugged::ReferenceError
      nil
    end

    def author_hash
      {
        name: rugged.config['user.name'], email: rugged.config['user.email'], nickname: rugged.config['user.nickname']
      }.freeze
    end

    def blobs(ref = DEFAULT_REF)
      return [] if empty?

      sha = sha_from_ref(ref)

      Blob.all(self, sha)
    end

    def find_blob(id, ref = DEFAULT_REF)
      ref ||= root_branch

      Blob.find(self, id, ref)
    end

    def find_commit(sha)
      Commit.find(self, sha)
    end

    def sha_from_ref(ref)
      rev_parse_target(ref).oid
    rescue Rugged::ReferenceError
      nil
    end

    def rev_parse_target(revspec)
      obj = rugged.rev_parse(revspec)
      Branch.dereference_object(obj)
    end

    def has_commits?
      !empty?
    end

    def merge_base_commit(from, to)
      rugged.merge_base(from, to)
    end

    def discover_default_branch
      names = branch_names

      return if names.empty?

      return names[0] if names.length == 1

      if head
        extracted_name = Branch.extract_branch_name(head.name)
        return extracted_name if names.include?(extracted_name)
      end

      names.include?(DEFAULT_BRANCH) ? DEFAULT_BRANCH : names[0]
    end

    def create(author:)
      Git.logger.info "Creating repository for <#{name}> from <#{path}>."
      # Ensure directory exists
      FileUtils.mkdir_p(path, mode: 0o770)

      # Create git repo
      repo = Rugged::Repository.init_at(path, :bare)
      repo.config['user.name'] = author.name
      repo.config['user.email'] = author.email
      repo.config['user.nickname'] = author.nickname
      repo.close

      # Create git hooks
      create_hooks
      true
    end

    def create_hooks
      local_hooks_directory = File.join(path, 'hooks')
      real_local_hooks_directory = :not_found

      begin
        real_local_hooks_directory = File.realpath(local_hooks_directory)
      rescue Errno::ENOENT
        # real_local_hooks_directory == :not_found
      end

      if real_local_hooks_directory != File.realpath(GLOBAL_HOOKS_DIRECTORY)
        if File.exist?(local_hooks_directory)
          Git.logger.info "Moving existing hooks directory and symlinking global hooks directory for #{path}."
          FileUtils.mv(local_hooks_directory, "#{local_hooks_directory}.old.#{Time.now.to_i}")
        end
        FileUtils.ln_sf(GLOBAL_HOOKS_DIRECTORY, local_hooks_directory)
      else
        Git.logger.info "Hooks already exist for #{path}."
        true
      end
    end

    def destroy
      Git.logger.info "Removing repository for <#{name}> from <#{path}>."
      FileUtils.rm_rf(path)
      true
    end

    def rename(new_path:)
      Git.logger.info "Moving repository from #{path} to <#{new_path}>."
      FileUtils.mv(path, new_path)
      true
    end
  end
end
