# frozen_string_literal: true


module Git
  class Repository
    include Branchable, Commitable

    class NoRepository < StandardError; end
    class InvalidBlobName < StandardError; end
    class InvalidRef < StandardError; end

    DEFAULT_NAME = 'blog.git'
    START_REF = 'HEAD'

    attr_reader :author_nickname, :author, :name, :full_name, :namespace_path,
    :path, :repository

    def initialize(author_nickname:, name: DEFAULT_NAME)
      @author_nickname = author_nickname
      @name = name
      @author ||= Person.find_by_nickname(author_nickname)

      @full_name = "#{author_nickname}/#{name}"
      @namespace_path = Git.config.git_storage_path.join(author_nickname).tap(&:mkpath).to_s
      @path = Git.config.git_storage_path.join(full_name).tap(&:mkpath).to_s
    end

    def reload
      @repository = nil
    end

    def empty?
      repository.empty?
    end

    def bare?
      repository.bare?
    end

    def repo_exists?
      !!repository
    end

    def size
      size = popen(%w(du -sk), path).first.strip.to_i
      (size.to_f / 1024).round(2)
    end

    def repository
      @repository ||= Rugged::Repository.new(path)
    rescue Rugged::RepositoryError, Rugged::OSError
      raise NoRepository.new('no repository for such path')
    end

    def root_branch
      @root_branch ||= discover_default_branch
    end

    def repository_head
      repository.head
    rescue Rugged::ReferenceError
      nil
    end

    def repository_index
      repository.index
    end

    def create
      repo = Rugged::Repository.init_at(path, :bare)
      repo.close
      true
    end

    def destroy
      Rails.logger.info "Removing repository for <#{name}> from <#{namespace_path}>."
      FileUtils.rm_rf(namespace_path)
      true
    end

    def rename(new_path)
      Rails.logger.info "Moving repository from #{path} to <#{new_path}>."
      FileUtils.mv(path, new_path)
    end

    def find_file(path, ref = nil)
      ref ||= root_branch
      sha = sha_from_ref(ref)
      Blob.find(self, sha, path)
    end

    def sha_from_ref(ref)
      rev_parse_target(ref).oid
    end

    def rev_parse_target(revspec)
      obj = repository.rev_parse(revspec)
      Branch.dereference_object(obj)
    end

    def lookup(oid_or_ref_name)
      repository.rev_parse(oid_or_ref_name)
    end
  end
end
